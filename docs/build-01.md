# BUILD 01 — TOI Service Foundation

Branch: build/01-toi-service-foundation

Adds an isolated Python FastAPI package, health endpoint, read-only item/opportunity listing, bounded pagination, PostgreSQL connection configuration and API contract tests. Existing schema.sql remains unchanged.

## Local validation
python -m pip install -e '.[test]'
pytest -q
uvicorn toi.app:app --reload

Apply modules/trend-intelligence/schema.sql to a dedicated PostgreSQL database before querying data. Configure TOI_DATABASE_URL via environment; do not commit credentials.

## Known limitations
No auth yet: do not expose the service publicly. No collectors, migration runner, DB integration tests, AI scoring, or deployment. /health does not validate database connectivity. Use a private development network only.

## Next
BUILD 02: source registry and RSS/official announcement adapters, YouTube API adapter, ingestion idempotency and provenance tests. Add authentication before production exposure.
