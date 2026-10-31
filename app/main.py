import os

from fastapi import FastAPI, HTTPException, Response
from prometheus_client import CONTENT_TYPE_LATEST, Counter, generate_latest
from pydantic import BaseModel

app = FastAPI(title="Task API")

APP_VERSION = os.getenv("APP_VERSION", "dev")
TASKS: dict[int, dict] = {}
REQUESTS = Counter("api_requests_total", "Total API requests", ["endpoint"])


class TaskIn(BaseModel):
    title: str


@app.get("/health")
def health():
    return {"status": "ok"}


@app.get("/version")
def version():
    REQUESTS.labels(endpoint="/version").inc()
    return {"version": APP_VERSION}


@app.post("/tasks", status_code=201)
def create_task(task: TaskIn):
    REQUESTS.labels(endpoint="/tasks").inc()
    task_id = len(TASKS) + 1
    TASKS[task_id] = {"id": task_id, "title": task.title, "done": False}
    return TASKS[task_id]


@app.get("/tasks")
def list_tasks():
    REQUESTS.labels(endpoint="/tasks").inc()
    return list(TASKS.values())


@app.get("/tasks/{task_id}")
def get_task(task_id: int):
    if task_id not in TASKS:
        raise HTTPException(status_code=404, detail="Task not found")
    return TASKS[task_id]


@app.get("/metrics")
def metrics():
    return Response(generate_latest(), media_type=CONTENT_TYPE_LATEST)
