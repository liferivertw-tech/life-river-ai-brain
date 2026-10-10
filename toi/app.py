"""TOI read-only API foundation. No external collectors run on import."""
from fastapi import FastAPI, HTTPException, Query
from pydantic import BaseModel, Field
import os

app = FastAPI(title="LIFE RIVER TOI", version="0.1.0")

class Item(BaseModel):
    id: int
    source_id: int
    url: str
    title: str
    language_code: str | None = None

class Opportunity(BaseModel):
    id: int
    title: str
    product_key: str
    score: int | None = Field(default=None, ge=0, le=100)
    status: str

def connect():
    import psycopg
    dsn = os.environ.get("TOI_DATABASE_URL")
    if not dsn:
        raise HTTPException(status_code=503, detail="Database not configured")
    try:
        return psycopg.connect(dsn, connect_timeout=3)
    except psycopg.OperationalError:
        raise HTTPException(status_code=503, detail="Database unavailable") from None

@app.get("/health")
def health():
    return {"status": "ok", "service": "toi", "version": "0.1.0"}

@app.get("/v1/toi/items", response_model=list[Item])
def items(limit: int = Query(default=20, ge=1, le=100)):
    with connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT id, source_id, url, title, language_code FROM toi.items ORDER BY fetched_at DESC, id DESC LIMIT %s", (limit,))
            return [Item(id=r[0], source_id=r[1], url=r[2], title=r[3], language_code=r[4]) for r in cur.fetchall()]

@app.get("/v1/toi/opportunities", response_model=list[Opportunity])
def opportunities(limit: int = Query(default=20, ge=1, le=100)):
    with connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT id, title, product_key, score, status FROM toi.opportunities ORDER BY created_at DESC, id DESC LIMIT %s", (limit,))
            return [Opportunity(id=r[0], title=r[1], product_key=r[2], score=r[3], status=r[4]) for r in cur.fetchall()]
