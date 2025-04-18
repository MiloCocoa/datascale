from mcp.server.fastmcp import FastMCP
import time
import signal
import sys
import os
from langchain_community.document_loaders import TextLoader
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_community.vectorstores import Chroma
from langchain_community.embeddings import HuggingFaceEmbeddings
from typing import Union, BinaryIO
from pydantic import BaseModel
import tempfile

APP_NAME        = "local_vec"
EMBEDDING_MODEL = "sentence-transformers/all-MiniLM-L6-v2"
CHUNK_SIZE      = 600
CHUNK_OVERLAP   = 200

# Create an MCP server with increased timeout
mcp = FastMCP(
    name=APP_NAME,
    # Add this to make the server more resilient
    timeout=30  # Increase timeout to 30 seconds
)

def load_vector_store(name: str, doc: Union[BinaryIO, bytes], embedding_model: str = EMBEDDING_MODEL):
    # Embedding
    print("Creating Embedding", file=sys.stderr)
    embeddings = HuggingFaceEmbeddings(model_name=embedding_model)
    print("Finish creating Embedding", file=sys.stderr)

    # Create a temporary file to store the document
    with tempfile.NamedTemporaryFile(mode='w', delete=False, suffix='.txt') as temp_file:
        if isinstance(doc, bytes): temp_file.write(doc.decode('utf-8'))
        else: temp_file.write(doc.read().decode('utf-8'))
        temp_file_path = temp_file.name

    try:
        # Load document from temporary file
        loader = TextLoader(temp_file_path)
        documents = loader.load()
    finally:
        # Clean up the temporary file
        os.unlink(temp_file_path)

    text_splitter = RecursiveCharacterTextSplitter(chunk_size=CHUNK_SIZE, chunk_overlap=CHUNK_OVERLAP)
    docs = text_splitter.split_documents(documents)

    current_dir = os.path.dirname(os.path.abspath(__file__))
    persistent_directory = os.path.join(current_dir, "db", f"chroma_db_{name}")

    print(f"Creating vector store : {persistent_directory}", file=sys.stderr)
    Chroma.from_documents(docs, embeddings, persist_directory=persistent_directory)

    return {"status": "success", "message": f"Vector store {name} processed successfully with {len(docs)} text chunks"}


@mcp.tool()
def create_chroma_database(document: Union[BinaryIO, bytes]) -> dict:
    """Create a chroma embedding vector database from a given document data.
    Args:
        document: The document data, either as bytes or a file-like object

    Returns:
        A success message or error description
    """
    try:
        # Handle the document based on its type
        # File-like object
        if hasattr(document, 'read'):
            document_data = document.read()
        elif isinstance(document, bytes):
            document_data = document
        else:
            raise ValueError("Document must be either bytes or a file-like object")

        return load_vector_store(name=APP_NAME, doc=document_data)
    except Exception as e:
        return {
            "status": "error",
            "message": f"Error: Failed to create chroma database - {str(e)}"
        }


@mcp.tool()
def search_chroma_database(query: str) -> dict:
    """Search the chroma vector database for a given query.
    Args:
        query: The query to search for

    Returns:
        Search results
    """
    try:
        # Load embeddings model
        embeddings = HuggingFaceEmbeddings(model_name=EMBEDDING_MODEL)

        # Get the path to the database
        current_dir = os.path.dirname(os.path.abspath(__file__))
        persistent_directory = os.path.join(current_dir, "db", f"chroma_db_{APP_NAME}")

        # Check if database exists
        if not os.path.exists(persistent_directory):
            return {"status": "error", "message": "Vector database has not been created yet. Please create it first."}

        # Load the existing vector store
        vector_store = Chroma(persist_directory=persistent_directory, embedding_function=embeddings)

        # Search for similar documents
        results = vector_store.similarity_search_with_score(query, k=5)

        # Format results
        formatted_results = []
        for doc, score in results:
            content = doc.page_content
            try:
                # If content appears to be base64 encoded, try to decode it
                import base64
                if all(c in 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=' for c in content):
                    decoded_content = base64.b64decode(content).decode('utf-8')
                    content = decoded_content
            except:
                # If decoding fails, keep the original content
                pass

            formatted_results.append({
                "content": content,
                "metadata": doc.metadata,
                "similarity_score": float(score)
            })

        return {
            "status": "success",
            "results": formatted_results,
            "message": f"Found {len(formatted_results)} results for query: '{query}'"
        }
    except Exception as e:
        return {
            "status": "error",
            "message": f"Error searching database: {str(e)}"
        }


if __name__ == "__main__":
    try:
        mcp.run()
    except Exception as e:
        print(f"Error: {e}")