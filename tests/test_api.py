from fastapi.testclient import TestClient
from toi.app import app

client = TestClient(app)

def test_health():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json()["service"] == "toi"

def test_limit_validation():
    assert client.get("/v1/toi/items?limit=101").status_code == 422
    assert client.get("/v1/toi/opportunities?limit=0").status_code == 422

def test_missing_database(monkeypatch):
    monkeypatch.delenv("TOI_DATABASE_URL", raising=False)
    assert client.get("/v1/toi/items").status_code == 503
