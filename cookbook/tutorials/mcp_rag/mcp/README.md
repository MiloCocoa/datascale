# MCP Vector Search Examples

This directory contains examples of how to use MCP (Model Control Protocol) with vector search functionality.

## Available Examples

### 1. Local Vector Search (`mcp_local_vec.py`)

This example shows how to create a local vector search MCP that uses Chroma and HuggingFace embeddings.

Features:
- Document embedding with sentence-transformers
- Text chunking with langchain
- Vector storage with Chroma
- Search functionality

### 2. Remote Vector Search (`mcp_remote_vec.py`)

This example demonstrates how to create an MCP client that connects to our FastAPI semantic search service.

Features:
- REST API integration with the FastAPI search service
- Environment variable configuration
- Result formatting
- Error handling

### 3. Simple MCP Demo (`mcp_simple.py`)

A simple demonstration of MCP functionality with basic examples.

## Running the Examples

### Running the MCP Server

Each MCP server can be run using the following command:

```bash
python example/mcp_remote_vec.py
```

### Testing the Remote Vector Search

You can test the remote vector search MCP using the provided test script:

```bash
# Set the API key environment variable
export VECTOR_API_KEY="your_api_key"

# Run the test script
python example/test_remote_vec.py
```

## Environment Variables

- `VECTOR_API_URL`: The base URL for the FastAPI search service
- `VECTOR_API_KEY`: The API key for authentication

## Dependencies

- `mcp`: The Model Control Protocol library
- `httpx`: Modern HTTP client for Python
- `langchain`: LLM application framework
- `sentence-transformers`: For embeddings
- `chromadb`: Vector database for local search