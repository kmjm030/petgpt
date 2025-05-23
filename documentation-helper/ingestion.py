import os
import re
import pickle
from langchain_core.documents import Document
from dotenv import load_dotenv

load_dotenv()

from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_google_genai import GoogleGenerativeAIEmbeddings
from langchain_pinecone import PineconeVectorStore

# ---------------- Global Configurations ----------------
GOOGLE_API_KEY = os.environ.get("GOOGLE_API_KEY")
PINECONE_API_KEY = os.environ.get("PINECONE_API_KEY")
PINECONE_INDEX_NAME = "petgpt-index"

# Text Splitting Parameters for the combined document
COMBINED_DOC_CHUNK_SIZE = 10000
COMBINED_DOC_CHUNK_OVERLAP = 1000

# Pinecone Batching Parameters
PINECONE_ADD_BATCH_SIZE = 32

# Initialize Embeddings
try:
    embeddings = GoogleGenerativeAIEmbeddings(
        model="models/embedding-001", google_api_key=GOOGLE_API_KEY
    )
except Exception as e:
    print(f"Error initializing GoogleGenerativeAIEmbeddings: {e}")
    embeddings = None


# ---------------- Core Ingestion Logic ----------------
def ingest_combined_document_to_pinecone(single_large_document: Document):
    """
    하나의 매우 큰 Document 객체를 받아서 청크로 분할하고 Pinecone에 추가합니다.
    """
    if not single_large_document or not single_large_document.page_content:
        print("Pinecone에 추가할 내용이 없습니다.")
        return
    if not embeddings:
        print("Embeddings not initialized. Skipping Pinecone ingestion.")
        return
    if not PINECONE_API_KEY:
        print("PINECONE_API_KEY not set. Skipping Pinecone ingestion.")
        return

    print(f"분할할 전체 문서의 글자 수: {len(single_large_document.page_content)}")

    text_splitter = RecursiveCharacterTextSplitter(
        chunk_size=COMBINED_DOC_CHUNK_SIZE,
        chunk_overlap=COMBINED_DOC_CHUNK_OVERLAP,
        length_function=len,
        is_separator_regex=False,
    )

    chunked_documents = text_splitter.split_documents([single_large_document])

    if not chunked_documents:
        print(
            "문서 분할 후 Pinecone에 추가할 청크가 없습니다. 원본 문서가 너무 작거나 chunk_size가 너무 클 수 있습니다."
        )
        return

    print(
        f"전체 텍스트를 {len(chunked_documents)}개의 청크로 분할했습니다 (청크 크기 목표: {COMBINED_DOC_CHUNK_SIZE})."
    )

    for i, chunk in enumerate(chunked_documents):
        chunk.metadata["chunk_sequence"] = i + 1
        chunk.metadata["original_sources"] = single_large_document.metadata.get(
            "source", "N/A"
        )
        chunk.metadata["original_title"] = single_large_document.metadata.get(
            "title", "N/A"
        )
        if "source" not in chunk.metadata:
            chunk.metadata["source"] = single_large_document.metadata.get(
                "source", f"chunk_{i+1}_of_combined_doc"
            )
        if "title" not in chunk.metadata:
            chunk.metadata["title"] = (
                f"Chunk {i+1} of {single_large_document.metadata.get('title', 'Combined Document')}"
            )

    print(f"\nInitializing Pinecone connection for index '{PINECONE_INDEX_NAME}'...")
    try:
        vector_store = PineconeVectorStore.from_existing_index(
            index_name=PINECONE_INDEX_NAME, embedding=embeddings
        )
    except Exception as e:
        print(f"Error connecting to Pinecone index '{PINECONE_INDEX_NAME}': {e}")
        return

    total_chunks = len(chunked_documents)
    print(
        f"Starting ingestion of {total_chunks} chunks into Pinecone index '{PINECONE_INDEX_NAME}'."
    )
    print(f"Using Pinecone add_documents batch size: {PINECONE_ADD_BATCH_SIZE}")

    log_batch_size = 100

    for i in range(0, total_chunks, log_batch_size):
        batch_to_submit = chunked_documents[i : i + log_batch_size]

        num_current_log_batch = (i // log_batch_size) + 1
        total_log_batches = (total_chunks + log_batch_size - 1) // log_batch_size

        print(
            f"  Submitting log batch {num_current_log_batch}/{total_log_batches} (chunks {i+1}-{min(i+log_batch_size, total_chunks)} of {total_chunks})"
        )
        try:
            vector_store.add_documents(
                documents=batch_to_submit, batch_size=PINECONE_ADD_BATCH_SIZE
            )
            print(
                f"    Successfully submitted {len(batch_to_submit)} chunks in log batch {num_current_log_batch}."
            )
        except Exception as e:
            print(
                f"    Error during add_documents for log batch {num_current_log_batch}: {e}"
            )
            for k, doc_problem in enumerate(
                batch_to_submit[: min(5, len(batch_to_submit))]
            ):
                print(
                    f"      Problem Doc {k}: metadata={doc_problem.metadata}, content_preview='{doc_problem.page_content[:100]}...'"
                )
            print("    Attempting to continue with next batch if any...")
            continue

    print(f"\nSuccessfully attempted ingestion of {total_chunks} chunks into Pinecone.")


# ---------------- Main Execution ----------------
if __name__ == "__main__":
    if not embeddings:
        print("Exiting due to embedding initialization error.")
        exit()
    if not PINECONE_API_KEY:
        print("PINECONE_API_KEY environment variable not set. Exiting.")
        exit()

    docs_folder_path = r"c:\CursorProjects\petgpt\documentation-helper\docs"
    all_markdown_content = ""
    processed_file_names = []

    print("Starting to read and combine markdown files...")
    for i in range(1, 35):
        file_name = f"doc{i}.md"
        markdown_file_path = os.path.join(docs_folder_path, file_name)

        if not os.path.exists(markdown_file_path):
            print(f"  File not found, skipping: {markdown_file_path}")
            continue

        print(f"  Reading file: {markdown_file_path}")
        try:
            with open(markdown_file_path, "r", encoding="utf-8") as f:
                all_markdown_content += (
                    f"\n\n===== START OF FILE: {file_name} =====\n\n"
                )
                all_markdown_content += f.read()
                all_markdown_content += f"\n\n===== END OF FILE: {file_name} =====\n\n"
                processed_file_names.append(file_name)
        except Exception as e:
            print(f"  Error reading file {markdown_file_path}: {e}")

    if all_markdown_content:
        print(
            f"\nSuccessfully combined content from {len(processed_file_names)} files."
        )
        print(
            f"Total combined content length (characters): {len(all_markdown_content)}"
        )

        combined_document_metadata = {
            "source_files": ", ".join(processed_file_names),
            "title": "Combined PetGPT Documentation (All Docs)",
            "document_type": "large_combined_document",
        }

        combined_document = Document(
            page_content=all_markdown_content.strip(),
            metadata=combined_document_metadata,
        )

        print(
            f"\n--- Starting Pinecone ingestion for the large combined document (target chunk size: {COMBINED_DOC_CHUNK_SIZE}) ---"
        )
        ingest_combined_document_to_pinecone(combined_document)
        print(
            "\n--- Combined document processed and ingestion to Pinecone attempted. ---"
        )
    else:
        print("\n--- No content was read from files. Pinecone ingestion skipped. ---")
