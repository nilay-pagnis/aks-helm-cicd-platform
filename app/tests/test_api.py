from fastapi.testclient import TestClient

from main import app

client = TestClient(app)


def test_health():
    r = client.get("/health")
    assert r.status_code == 200
    assert r.json() == {"status": "ok"}


def test_create_and_get_task():
    r = client.post("/tasks", json={"title": "learn helm"})
    assert r.status_code == 201
    task_id = r.json()["id"]

    r = client.get(f"/tasks/{task_id}")
    assert r.status_code == 200
    assert r.json()["title"] == "learn helm"


def test_missing_task():
    assert client.get("/tasks/9999").status_code == 404


def test_metrics_endpoint():
    r = client.get("/metrics")
    assert r.status_code == 200
    assert "api_requests_total" in r.text

def test_ping():
    r = client.get("/ping")
    assert r.status_code == 200
    assert r.json() == {"message": "pong"}