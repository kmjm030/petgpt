import json
import os
from dotenv import load_dotenv
import mysql.connector
from datetime import datetime
from langchain.schema.document import Document

load_dotenv()

DB_CONFIG = {
    "host": "118.67.143.55",
    "user": "mcuser",
    "password": "111111",
    "database": "petgpt",
}


def get_db_connection():
    try:
        conn = mysql.connector.connect(**DB_CONFIG, charset="utf8mb4")
        print("Successfully connected to MySQL.")
        return conn
    except mysql.connector.Error as err:
        print(f"Error connecting to MySQL: {err}")
        return None


def fetch_all_customers(cursor):
    cursor.execute("SELECT cust_id, cust_nick FROM customer")
    return {row["cust_id"]: row["cust_nick"] for row in cursor.fetchall()}


def fetch_all_admins(cursor):
    cursor.execute("SELECT admin_id, admin_name FROM admin")
    return {row["admin_id"]: row["admin_name"] for row in cursor.fetchall()}


def fetch_all_categories(cursor):
    cursor.execute("SELECT category_key, category_name FROM category")
    return {row["category_key"]: row["category_name"] for row in cursor.fetchall()}


def fetch_item_names_map(cursor):
    cursor.execute("SELECT item_key, item_name FROM item")
    return {row["item_key"]: row["item_name"] for row in cursor.fetchall()}


def create_product_documents(cursor, categories_map):
    print("Creating product documents...")
    langchain_documents = []
    query = """
        SELECT
            i.item_key, i.category_key, i.item_name, i.item_content,
            i.item_price, i.item_sprice, i.item_rdate, i.item_img1,
            i.sales_count, i.is_active,
            id.item_detail
        FROM item i
        LEFT JOIN item_details id ON i.item_key = id.item_key
    """
    cursor.execute(query)
    items = cursor.fetchall()

    for item in items:
        category_name = categories_map.get(item["category_key"], "")

        # page_content: 임베딩 대상이 될 주요 텍스트 정보
        page_content = f"상품명: {item.get('item_name', '')}\n"
        page_content += f"카테고리: {category_name}\n"
        if item.get("item_content"):
            page_content += f"간단 설명: {item.get('item_content')}\n"
        if item.get("item_detail"):
            page_content += f"상세 설명: {item.get('item_detail')}\n"
        page_content = page_content.strip()

        # metadata: 검색 결과 필터링이나 추가 정보 표시에 사용될 정보
        metadata = {
            "source": f"petgpt_db_product_{item['item_key']}",  # 출처를 명시
            "doc_type": "product",
            "item_key": item["item_key"],
            "item_name": item.get("item_name") or "",
            "category_name": category_name,
            "item_price": item.get("item_price", 0),
            "item_rdate": (
                item["item_rdate"].isoformat() if item.get("item_rdate") else ""
            ),
            "is_active": bool(item.get("is_active", 0)),
        }
        if item.get("item_sprice") is not None:
            metadata["item_sprice"] = item.get("item_sprice")
        if item.get("item_img1"):
            metadata["item_img1"] = item.get("item_img1")
        if item.get("sales_count") is not None:
            metadata["sales_count"] = item.get("sales_count")

        # 옵션 정보도 메타데이터에 추가 (문자열 형태로 간단히)
        cursor.execute(
            "SELECT option_name, size, color FROM `option` WHERE item_key = %s LIMIT 5",
            (item["item_key"],),
        )  # 너무 많으면 일부만
        options_raw = cursor.fetchall()
        if options_raw:
            options_str_list = []
            for opt in options_raw:
                opt_str = opt.get("option_name", "")
                if opt.get("size") and opt.get("size") != "FREE":
                    opt_str += f" (사이즈: {opt.get('size')})"
                if (
                    opt.get("color")
                    and opt.get("color") != "화이트"
                    and opt.get("color") != "기본"
                ):  # 의미 없는 기본값 제외
                    opt_str += f" (색상: {opt.get('color')})"
                options_str_list.append(opt_str.strip())
            metadata["options_preview"] = ", ".join(options_str_list)

        langchain_documents.append(
            Document(page_content=page_content, metadata=metadata)
        )
    print(f"Created {len(langchain_documents)} product documents.")
    return langchain_documents


def create_community_post_documents(cursor, customer_nicknames, admin_names):
    print("Creating community post documents...")
    langchain_documents = []
    query = """
        SELECT
            b.board_key, b.cust_id, b.category,
            b.board_title, b.board_content, b.reg_date
        FROM communityboard b
    """
    cursor.execute(query)
    posts = cursor.fetchall()

    for post in posts:
        cust_nick = customer_nicknames.get(post["cust_id"]) or admin_names.get(
            post["cust_id"], post.get("cust_id") or "unknown_user"
        )

        page_content = f"게시판 종류: {post.get('category', '')}\n"
        page_content += f"제목: {post.get('board_title', '')}\n"
        if post.get("board_content"):
            page_content += f"내용: {post.get('board_content')}\n"
        page_content += f"작성자: {cust_nick}"
        page_content = page_content.strip()

        metadata = {
            "source": f"petgpt_db_community_post_{post['board_key']}",
            "doc_type": "community_post",
            "board_key": post["board_key"],
            "author_nickname": cust_nick,
            "category": post.get("category") or "",
            "title": post.get("board_title") or "",
            "reg_date": post["reg_date"].isoformat() if post.get("reg_date") else "",
        }
        langchain_documents.append(
            Document(page_content=page_content, metadata=metadata)
        )
    print(f"Created {len(langchain_documents)} community post documents.")
    return langchain_documents


def create_community_comment_documents(cursor, customer_nicknames, item_names_map):
    print("Creating community comment documents...")
    langchain_documents = []
    query = """
        SELECT
            c.comments_key, c.pboard_key, c.cust_id,
            c.comments_content, c.comments_rdate,
            b.board_title AS parent_post_title,
            i.item_name AS linked_item_name
        FROM comments c
        JOIN communityboard b ON c.pboard_key = b.board_key
        LEFT JOIN item i ON b.item_key = i.item_key
    """
    cursor.execute(query)
    comments_data = cursor.fetchall()

    for comment in comments_data:
        cust_nick = customer_nicknames.get(
            comment["cust_id"], comment.get("cust_id") or "unknown_user"
        )

        page_content = (
            f"게시글 \"{comment.get('parent_post_title', '')}\"에 대한 댓글:\n"
        )
        if comment.get("linked_item_name"):
            page_content += f"(관련 상품: {comment.get('linked_item_name')})\n"
        page_content += f"작성자: {cust_nick}\n"
        page_content += f"댓글 내용: {comment.get('comments_content', '')}"
        page_content = page_content.strip()

        metadata = {
            "source": f"petgpt_db_comment_{comment['comments_key']}",
            "doc_type": "community_comment",
            "comment_key": comment["comments_key"],
            "parent_board_key": comment["pboard_key"],
            "author_nickname": cust_nick,
            "comment_date": (
                comment["comments_rdate"].isoformat()
                if comment.get("comments_rdate")
                else ""
            ),
        }
        langchain_documents.append(
            Document(page_content=page_content, metadata=metadata)
        )
    print(f"Created {len(langchain_documents)} community comment documents.")
    return langchain_documents


def create_product_qna_documents(cursor, customer_nicknames, item_names_map):
    print("Creating product Q&A/review documents...")
    langchain_documents = []
    query = """
        SELECT
            q.board_key, q.item_key, q.board_type,
            q.cust_id, q.board_title, q.board_rdate, q.board_content,
            q.board_score
        FROM qnaboard q
    """
    cursor.execute(query)
    qna_items = cursor.fetchall()

    for qna in qna_items:
        item_name = item_names_map.get(qna["item_key"], "알 수 없는 상품")
        doc_type_str = "Q&A" if qna.get("board_type") == 1 else "리뷰"
        cust_nick = customer_nicknames.get(
            qna["cust_id"], qna.get("cust_id") or "unknown_user"
        )

        page_content = f'상품 "{item_name}"에 대한 {doc_type_str}\n'
        page_content += f"제목: {qna.get('board_title', '')}\n"
        if qna.get("board_content"):
            page_content += f"내용: {qna.get('board_content')}\n"
        page_content += f"작성자: {cust_nick}"
        if doc_type_str == "리뷰" and qna.get("board_score") is not None:
            page_content += f"\n평점: {qna.get('board_score')}/5"
        page_content = page_content.strip()

        metadata = {
            "source": f"petgpt_db_qna_{qna['board_key']}",
            "doc_type": "product_qna" if doc_type_str == "Q&A" else "product_review",
            "qna_key": qna["board_key"],
            "item_name": item_name,
            "author_nickname": cust_nick,
            "title": qna.get("board_title") or "",
            "qna_date": (
                qna["board_rdate"].isoformat() if qna.get("board_rdate") else ""
            ),
        }
        if qna.get("item_key") is not None:
            metadata["item_key"] = qna.get("item_key")
        if qna.get("board_score") is not None:
            metadata["rating_score"] = qna.get("board_score")

        langchain_documents.append(
            Document(page_content=page_content, metadata=metadata)
        )
    print(f"Created {len(langchain_documents)} product Q&A/review documents.")
    return langchain_documents


def create_admin_notice_documents(cursor, admin_names):
    print("Creating admin notice documents...")
    langchain_documents = []
    query = """
        SELECT
            an.id, an.admin_id, an.title, an.content, an.created_at, an.admin_name
        FROM admin_notice an
    """
    try:
        cursor.execute(query)
        notices = cursor.fetchall()
    except mysql.connector.Error as err:
        print(
            f"Could not fetch admin_notice: {err}. Skipping admin notices processing."
        )
        return langchain_documents

    for notice in notices:
        admin_display_name = notice.get("admin_name") or admin_names.get(
            notice["admin_id"], notice.get("admin_id") or "관리자"
        )

        page_content = f"공지사항 제목: {notice.get('title', '')}\n"
        if notice.get("content"):
            page_content += f"내용: {notice.get('content')}\n"
        page_content += f"작성자: {admin_display_name}"
        page_content = page_content.strip()

        metadata = {
            "source": f"petgpt_db_admin_notice_{notice['id']}",
            "doc_type": "admin_notice",
            "notice_id": notice["id"],
            "author_name": admin_display_name,
            "title": notice.get("title") or "",
            "created_date": (
                notice["created_at"].isoformat() if notice.get("created_at") else ""
            ),
        }
        langchain_documents.append(
            Document(page_content=page_content, metadata=metadata)
        )
    print(f"Created {len(langchain_documents)} admin notice documents.")
    return langchain_documents


def generate_langchain_documents_from_db():
    conn = get_db_connection()
    if not conn:
        return []

    all_langchain_docs = []
    try:
        with conn.cursor(dictionary=True) as cursor:
            customer_nicknames = fetch_all_customers(cursor)
            admin_names = fetch_all_admins(cursor)
            categories_map = fetch_all_categories(cursor)
            item_names_map = fetch_item_names_map(cursor)

            all_langchain_docs.extend(create_product_documents(cursor, categories_map))
            all_langchain_docs.extend(
                create_community_post_documents(cursor, customer_nicknames, admin_names)
            )
            all_langchain_docs.extend(
                create_community_comment_documents(
                    cursor, customer_nicknames, item_names_map
                )
            )
            all_langchain_docs.extend(
                create_product_qna_documents(cursor, customer_nicknames, item_names_map)
            )
            all_langchain_docs.extend(
                create_admin_notice_documents(cursor, admin_names)
            )
    except Exception as e:
        print(f"An error occurred during database processing: {e}")
    finally:
        if conn and conn.is_connected():
            conn.close()
            print("MySQL connection closed.")

    print(f"\nTotal Langchain documents created from DB: {len(all_langchain_docs)}")
    return all_langchain_docs


if __name__ == "__main__":
    db_documents = generate_langchain_documents_from_db()

    if db_documents:
        import pickle

        output_folder = "db_langchain_docs"
        os.makedirs(output_folder, exist_ok=True)
        file_path = os.path.join(output_folder, "petgpt_db_documents.pkl")

        with open(file_path, "wb") as f:
            pickle.dump(db_documents, f)
        print(f"Langchain documents saved to {file_path}")
        print("\n--- Example of first created Langchain Document ---")
        print(f"Page Content:\n{db_documents[0].page_content}")
        print(
            f"Metadata:\n{json.dumps(db_documents[0].metadata, indent=2, ensure_ascii=False)}"
        )
        print("-------------------------------------------------")
