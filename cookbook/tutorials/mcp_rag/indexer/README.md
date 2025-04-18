# Markdown Vector Search Indexer

A tool for indexing markdown files into Supabase's pgvector for semantic search.

## Features

- Recursively finds all .md files in a specified directory
- Splits content into optimally sized chunks using RecursiveCharacterTextSplitter
- Generates embeddings using Google's Gemini embedding model
- Uploads chunks and embeddings to Supabase for vector search
- Handles batching to avoid rate limits
- Maintains file-chunk relationship for easy retrieval

## Requirements

- Python 3.8+
- Supabase project with pgvector extension enabled
- Google Gemini API key

## Setup

1. Create a `.env` file with the following variables:

```
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_KEY=your-supabase-key
GEMINI_API_KEY=your-gemini-api-key
GEMINI_EMBEDDING_ID=text-embedding-004
```

2. Install the required dependencies:

```bash
pip install langchain-text-splitters google-generativeai supabase python-dotenv
```

3. Make sure your Supabase database has a `file_embeddings` table with the following schema:

```sql
create table file_embeddings (
  id          text PRIMARY KEY NOT NULL,
  file_id     text NOT NULL,
  content     text,
  embedding   vector(768),
  updated_at  timestamp with time zone not null default (now() AT TIME ZONE 'utc')
);

create index on file_embeddings using hnsw (embedding vector_ip_ops);
```

4. Create a match function in Supabase:

```sql
create or replace function match_file_embeddings(
  p_query_embedding vector(768),
  p_match_threshold float,
  p_match_count int
)
returns table (
  id text,
  file_id text,
  content text,
  similarity float
)
language sql
as $$
  with top_embeddings as (
    select
      e.id,
      e.file_id,
      e.content,
      -- Calculate similarity (negative inner product)
      -(e.embedding <#> p_query_embedding) as similarity
    from file_embeddings e
    where e.embedding <#> p_query_embedding < -p_match_threshold
    order by e.embedding <#> p_query_embedding
    limit least(p_match_count, 50)
  )
  select *
  from top_embeddings;
$$;
```

## Usage

Run the indexer on a directory of markdown files:

```bash
# Index all markdown files in the current directory
python indexer.py

# Index markdown files in a specific directory
python indexer.py /path/to/markdown/files

# Perform a dry run without uploading to Supabase
python indexer.py --dry-run
```

### Example

```bash
# Index all markdown files in the docs directory
python indexer.py ./docs

# Expected output:
Found 42 markdown files in ./docs
Processed ./docs/intro.md - 3 chunks
Processed ./docs/setup.md - 5 chunks
...
Processing embedding batch 1 (75 chunks)...
Processing embedding batch 2 (20 chunks)...
Indexed batch 1 (95 chunks) to Supabase

Success: Processed 42 files and indexed 95 chunks in 12.34 seconds
Statistics:
  files_processed: 42
  files_failed: 0
  chunks_created: 95
  chunks_indexed: 95
  processing_time: 12.34
```

## How It Works

1. The script recursively finds all `.md` files in the specified directory
2. Each file is read and split into chunks using RecursiveCharacterTextSplitter
3. Chunk IDs are created using the format `{file_path}_{start_position}-{end_position}`
4. Embeddings are generated for each chunk using Gemini (in batches of 100 chunks maximum)
5. The chunks and embeddings are uploaded to Supabase (in batches of 500 records maximum)

## Optimization Notes

- The default chunk size is 600 characters with a 200 character overlap
- Files are processed in batches of 20 to avoid overwhelming memory
- Embeddings are generated in batches of 100 (Gemini API limit)
- Uploads to Supabase are done in batches of 500 (to avoid large payloads)
- Batch processing includes progress reporting and error handling
- Rate limiting is implemented to avoid API throttling