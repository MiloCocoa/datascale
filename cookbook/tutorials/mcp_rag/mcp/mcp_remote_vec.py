from mcp.server.fastmcp import FastMCP
import httpx
import json
import os
from typing import Optional, Dict, List, Any

APP_NAME     = "remote_vec"
API_BASE_URL = os.environ.get("VECTOR_API_URL", "http://localhost:8000/api/v1")
API_KEY      = os.environ.get("VECTOR_API_KEY", "mcp-vector-search-api-key")
API_HEADERS  = {
    "X-API-Key"   : API_KEY,
    "Content-Type": "application/json"
}

# Create an MCP server with increased timeout
mcp = FastMCP(
    name=APP_NAME,
    timeout=30  # Increase timeout to 30 seconds
)

# =================================================================================================
# Tools
# =================================================================================================

@mcp.tool()
def semantic_search(query: str, match_threshold: Optional[float] = 0.5, match_count: Optional[int] = 20) -> str:
    """
    Search the vector database for a given query using the remote API.

    Args:
        query: The search query
        match_threshold: Optional, Similarity threshold (0.0 to 1.0), default: 0.5
        match_count: Optional, Maximum number of results to return, default: 20
    Returns:
        Search results containing matching documents
    """
    try:
        # Prepare the request to the search API
        payload = {
            "query"          : query,
            "match_threshold": match_threshold,
            "match_count"    : match_count
        }

        # Make the API request
        response = httpx.post(
            url     = f"{API_BASE_URL}/search",
            headers = API_HEADERS,
            json    = payload,
        )

        # Check for successful response
        if response.status_code == 200:
            result = response.json()
            response = {
                "status" : "success",
                "results": result["results"],
                "message": f"Found {len(result['results'])} results for query: '{query}'"
            }
            return format_search_results(response)
        else:
            error_message = response.text
            try:
                error_json = response.json()
                if "detail" in error_json:
                    error_message = error_json["detail"]
            except: pass

            return f"API error (HTTP {response.status_code}): {error_message}"

    except Exception as e:
        return f"Error during API request: {str(e)}"

# =================================================================================================
# Helpers
# =================================================================================================


def format_search_results(search_response: Dict) -> str:
    """
    Format search results into a readable string format.

    Args:
        search_response: The response from search_vector_database

    Returns:
        Formatted string with search results
    """
    if search_response.get("status") != "success":
        return f"Error: {search_response.get('message', 'Unknown error')}"

    results = search_response.get("results", [])
    if not results:
        return "No matching documents found."

    formatted = f"Found {len(results)} matching documents:\n\n"

    for i, result in enumerate(results, 1):
        similarity = result.get("similarity", 0)
        formatted += f"Result #{i} [Similarity: {similarity:.3f}]\n"
        formatted += f"ID: {result.get('id')}\n"
        formatted += f"File ID: {result.get('file_id')}\n"

        # Truncate content if it's too long
        content = result.get("content", "")
        if len(content) > 1000:
            content = content[:997] + "..."

        formatted += f"Content: {content}\n\n"

    return formatted

# =================================================================================================

def main():
    print(f"Starting {APP_NAME} MCP server...")
    print(f"API URL: {API_BASE_URL}")
    mcp.run()

if __name__ == "__main__":
    main()
