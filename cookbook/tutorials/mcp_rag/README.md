# MCP - Vector Search API

A FastAPI-based semantic search API using Gemini embeddings and Supabase pgvector.

## Setup

### ENVs
```
API_KEY=your_api_key
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_KEY=your_supabase_key
GEMINI_API_KEY=your_gemini_api_key
GEMINI_EMBEDDING_ID=text-embedding-004
RAG_EMBEDDING_SIZE=768
RAG_MATCH_THRESHOLD=0.36
RAG_MATCH_COUNT=4
```

### Command
```bash
uv init vector-search
cd vector-search

uv venv --python 3.11.6

# mcp server
uv add mcp httpx

# local search
uv add langchain langchain-community sentence-transformers chromadb

# supabase search
uv add supabase google-genai fastapi

# Create a symlink to uv in a standard location
sudo ln -s $(which uv) /usr/local/bin/uv

# Basic
mcp dev mcp_simple.py

mcp install example/mcp_simple.py


```

## Running the API

```bash
uvicorn main:app --reload
```

## API Usage

### Search Endpoint

**URL**: `/api/v1/search`
**Method**: POST
**Auth**: Requires X-API-Key header

**Request Body**:
```json
{
  "query": "your search query",
  "match_threshold": 0.36,
  "match_count": 4
}
```

**Response**:
```json
{
  "results": [
    {
      "id": "1",
      "file_id": "file1",
      "content": "Content of the document chunk",
      "similarity": 0.89
    },
    ...
  ]
}
```

## Example cURL

```bash
curl -X POST "http://localhost:8000/api/v1/search" \
  -H "X-API-Key: your_api_key" \
  -H "Content-Type: application/json" \
  -d '{"query": "your search query"}'
```
