-- Enable the vector extension
create extension vector
with
  schema extensions;

-- Create the file_embeddings table
-- drop table file_embeddings;
create table file_embeddings (
  id          text PRIMARY KEY NOT NULL,
  file_id     text NOT NULL,
  content     text,

  -- Search
  fts         tsvector generated always as (to_tsvector('english', content)) stored,
  embedding   vector(768),

  -- Metadata
  updated_at  timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
);

-- INDEXING
-- Create an index for the full-text search
create index on file_embeddings using gin(fts);

-- Create an index for the semantic vector search
-- We are using the vector_ip_ops (inner product) operator with this index
-- because we plan on using the inner product (<#>) operator later
create index on file_embeddings using hnsw (embedding vector_ip_ops);

-- SECURITY
-- Create a policy to allow the authenticated role to read by Org ID
alter table "public"."file_embeddings"
enable row level security;
