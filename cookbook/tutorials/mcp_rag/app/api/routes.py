from fastapi import APIRouter, Depends, HTTPException, Security, status
from fastapi.security.api_key import APIKeyHeader
from typing import Dict, List, Any
from config import settings
from services.search import search_documents
from models.search import SearchRequest, SearchResult, SearchResponse

router = APIRouter()

# Define API key security
api_key_header = APIKeyHeader(name="X-API-Key")

# Validate API key
async def get_api_key(api_key: str = Security(api_key_header)):
    if api_key != settings.API_KEY:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid API Key"
        )
    return api_key


@router.post("/search", response_model=SearchResponse, tags=["search"])
async def search(
    request: SearchRequest,
    api_key: str = Depends(get_api_key)
) -> Dict[str, List[Dict[str, Any]]]:
    """
    Search for documents using semantic search

    This endpoint performs semantic search using Gemini embeddings and Supabase pgvector.
    It returns documents matching the query ranked by similarity.
    """
    results = await search_documents(
        query           = request.query,
        match_threshold = request.match_threshold,
        match_count     = request.match_count
    )

    return {"results": results}
