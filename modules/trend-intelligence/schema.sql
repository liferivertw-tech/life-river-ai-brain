-- TOI schema V0.1 (PostgreSQL proposal; not yet deployed)
CREATE SCHEMA IF NOT EXISTS toi;
CREATE TABLE IF NOT EXISTS toi.sources (
 id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 name TEXT NOT NULL,
 kind TEXT NOT NULL,
 origin_url TEXT NOT NULL,
 access_method TEXT NOT NULL,
 enabled BOOLEAN NOT NULL DEFAULT FALSE,
 created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS toi.items (
 id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 source_id BIGINT NOT NULL REFERENCES toi.sources(id),
 external_id TEXT,
 url TEXT NOT NULL,
 title TEXT NOT NULL,
 published_at TIMESTAMPTZ,
 fetched_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
 language_code TEXT,
 metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
 UNIQUE(source_id,url)
);
CREATE TABLE IF NOT EXISTS toi.opportunities (
 id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 title TEXT NOT NULL,
 rationale TEXT NOT NULL,
 product_key TEXT NOT NULL,
 score INTEGER CHECK(score BETWEEN 0 AND 100),
 status TEXT NOT NULL DEFAULT 'draft' CHECK(status IN ('draft','review','approved','rejected')),
 created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS toi.opportunity_evidence (
 opportunity_id BIGINT NOT NULL REFERENCES toi.opportunities(id),
 item_id BIGINT NOT NULL REFERENCES toi.items(id),
 PRIMARY KEY(opportunity_id,item_id)
);
CREATE TABLE IF NOT EXISTS toi.reviews (
 id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 opportunity_id BIGINT NOT NULL REFERENCES toi.opportunities(id),
 reviewer_id TEXT NOT NULL,
 decision TEXT NOT NULL CHECK(decision IN ('approved','rejected','needs_revision')),
 notes TEXT,
 reviewed_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
