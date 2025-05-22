import os
import pickle
from xml.dom.minidom import Document
from dotenv import load_dotenv

load_dotenv()

from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_community.document_loaders import ReadTheDocsLoader
from langchain_google_genai import GoogleGenerativeAIEmbeddings
from langchain_pinecone import PineconeVectorStore
from firecrawl import FirecrawlApp, JsonConfig
from pydantic import BaseModel, Field

embeddings = GoogleGenerativeAIEmbeddings(
    model="models/embedding-001", google_api_key=os.environ.get("GOOGLE_API_KEY")
)


def load_db_documents_from_pickle(
    folder_path="docs", filename="petgpt_db_documents.pkl"
):
    file_path = os.path.join(folder_path, filename)
    if os.path.exists(file_path):
        with open(file_path, "rb") as f:
            loaded_docs = pickle.load(f)
        print(f"Successfully loaded {len(loaded_docs)} documents from {file_path}")
        return loaded_docs
    else:
        print(f"Pickle file {file_path} not found.")
        return []


def ingest_docs(raw_documents):
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=500, chunk_overlap=100)
    documents = text_splitter.split_documents(raw_documents)

    print(f"Prepared {len(documents)} documents for Pinecone")

    from pinecone import Pinecone

    pc = Pinecone(api_key=os.environ["PINECONE_API_KEY"])
    index_name = "petgpt-index"

    vector_store = PineconeVectorStore.from_existing_index(
        index_name=index_name, embedding=embeddings
    )

    # --- 수동 배칭 시작 ---
    manual_submission_batch_size = 100
    pinecone_api_internal_batch_size = 4

    total_docs = len(documents)
    print(
        f"Adding {total_docs} documents to Pinecone index '{index_name}' using manual submission batches of {manual_submission_batch_size} and internal API batch size of {pinecone_api_internal_batch_size}"
    )

    for i in range(0, total_docs, manual_submission_batch_size):
        batch_to_submit = documents[i : i + manual_submission_batch_size]

        num_current_batch = (i // manual_submission_batch_size) + 1
        total_manual_batches = (
            total_docs + manual_submission_batch_size - 1
        ) // manual_submission_batch_size

        print(
            f"Processing manual batch {num_current_batch}/{total_manual_batches}: Adding {len(batch_to_submit)} documents"
        )

        try:
            vector_store.add_documents(
                batch_to_submit, batch_size=pinecone_api_internal_batch_size
            )
            print(f"Successfully added manual batch {num_current_batch}")
        except Exception as e:
            print(
                f"Error during add_documents for manual batch {num_current_batch} (starting at index {i}): {e}"
            )
            print("Problematic batch documents (first few):")
            for k, doc_problem in enumerate(
                batch_to_submit[: min(3, len(batch_to_submit))]
            ):
                print(
                    f"  Doc {k}: source='{doc_problem.metadata.get('source', 'N/A')}', content_len={len(doc_problem.page_content)}"
                )
            raise e

    print("Successfully added all documents.")
    # --- 수동 배칭 끝 ---


def ingest_docs2() -> None:
    firecrawl_api_key = os.environ.get("FIRECRAWL_API_KEY")
    firecrawl_app = FirecrawlApp(api_key=firecrawl_api_key)

    langchain_documents_base_urls = [
        "https://python.langchain.com/docs/integrations/chat/",
        "https://python.langchain.com/docs/integrations/llms/",
        "https://python.langchain.com/docs/integrations/text_embedding/",
        "https://python.langchain.com/docs/integrations/document_loaders/",
        "https://python.langchain.com/docs/integrations/document_transformers/",
        "https://python.langchain.com/docs/integrations/vectorstores/",
        "https://python.langchain.com/docs/integrations/retrievers/",
        "https://python.langchain.com/docs/integrations/tools/",
        "https://python.langchain.com/docs/integrations/stores/",
        "https://python.langchain.com/docs/integrations/llm_caching/",
        "https://python.langchain.com/docs/integrations/graphs/",
        "https://python.langchain.com/docs/integrations/memory/",
        "https://python.langchain.com/docs/integrations/callbacks/",
        "https://python.langchain.com/docs/integrations/chat_loaders/",
        "https://python.langchain.com/docs/concepts/",
    ]

    all_docs_for_pinecone = []

    for url in langchain_documents_base_urls:
        print(f"Crawling URL: {url} using firecrawl-py directly...")
        try:
            crawled_data_list = firecrawl_app.crawl_url(url)

            if not crawled_data_list:
                print(f"No data crawled from {url}")
                continue

            print(f"Successfully crawled {len(crawled_data_list)} pages from {url}")

            current_url_docs = []
            for item in crawled_data_list:
                page_content = item.get("markdown", "")
                metadata = item.get("metadata", {})

                if "source" not in metadata:
                    metadata["source"] = item.get("url", url)

                if page_content:
                    current_url_docs.append(
                        Document(page_content=page_content, metadata=metadata)
                    )

            print(
                f"Converted {len(current_url_docs)} crawled items from {url} to LangChain Documents."
            )
            all_docs_for_pinecone.extend(current_url_docs)

        except Exception as e:
            print(f"Error crawling {url}: {e}")
            continue

    documents_to_index = all_docs_for_pinecone

    print(
        f"Going to add {len(documents_to_index)} documents to Pinecone index 'firecrawl-index'"
    )

    try:
        PineconeVectorStore.from_documents(
            documents_to_index, embeddings, index_name="firecrawl-index"
        )
        print(f"****Loading all crawled data to vectorstore 'firecrawl-index' done ***")
    except Exception as e:
        print(f"Error adding documents to Pinecone: {e}")


if __name__ == "__main__":
    ingest_docs(
        load_db_documents_from_pickle(
            folder_path="docs", filename="petgpt_db_documents.pkl"
        )
    )
