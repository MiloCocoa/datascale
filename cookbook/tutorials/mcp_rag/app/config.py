from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):
    API_KEY                 : str   = "mcp-vector-search-api-key"

    # Supabase
    SUPABASE_URL            : str   = "https://<PROJECT_ID>.supabase.co"
    SUPABASE_KEY            : str

    # Gemini
    GEMINI_API_KEY          : str
    GEMINI_MODEL_ID         : str
    GEMINI_EMBEDDING_ID     : str   = "text-embedding-004"

    # RAG
    RAG_ENABLED             : bool  = True
    RAG_EMBEDDING_SIZE      : int   = 768
    RAG_MATCH_THRESHOLD     : float = 0.36
    RAG_MATCH_COUNT         : int   = 4

    model_config = SettingsConfigDict(env_file=".env")

settings = Settings()