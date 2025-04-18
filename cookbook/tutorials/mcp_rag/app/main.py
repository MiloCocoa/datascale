from fastapi import FastAPI
from api.routes import router as vector_search


def create_app() -> FastAPI:
    """
    Create and configure the FastAPI application.

    Returns:
        FastAPI: The configured FastAPI application instance.
    """
    app = FastAPI(
        title="Vector Search API",
        description="API for vector search using Supabase's pgvector.",
        version="1.0.0",
    )

    # Include the router for the vector search API
    app.include_router(vector_search, prefix="/api/v1", tags=["vector-search"])

    return app


app = create_app()