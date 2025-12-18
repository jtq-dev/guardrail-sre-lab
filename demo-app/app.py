import os, time, random, logging
from fastapi import FastAPI, Response
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST

LOG_FILE = os.getenv("LOG_FILE", "/tmp/app.log")
os.makedirs(os.path.dirname(LOG_FILE), exist_ok=True)

logging.basicConfig(
    level=logging.INFO,
    format="ts=%(asctime)s level=%(levelname)s msg=%(message)s",
    handlers=[logging.FileHandler(LOG_FILE), logging.StreamHandler()],
)

app = FastAPI()

REQS = Counter("http_requests_total", "Total HTTP requests", ["route", "status"])
LAT = Histogram(
    "http_request_duration_seconds",
    "Request latency",
    ["route"],
    buckets=(0.05, 0.1, 0.2, 0.4, 0.8, 1.5, 3.0)
)

@app.get("/health")
def health():
    return {"ok": True}

@app.get("/hello")
def hello():
    start = time.time()
    # simulate latency
    time.sleep(random.choice([0.02, 0.05, 0.09, 0.15, 0.35, 0.6]))
    dur = time.time() - start
    LAT.labels("/hello").observe(dur)
    REQS.labels("/hello", "200").inc()
    logging.info("route=/hello status=200 latency=%.3f", dur)
    return {"message": "hello from demo-app", "latency_s": round(dur, 3)}

@app.get("/error")
def err():
    start = time.time()
    time.sleep(random.choice([0.05, 0.12, 0.3]))
    dur = time.time() - start
    LAT.labels("/error").observe(dur)
    REQS.labels("/error", "500").inc()
    logging.error("route=/error status=500 latency=%.3f ERROR=simulated_failure", dur)
    return Response(content="simulated error", status_code=500)

@app.get("/metrics")
def metrics():
    return Response(generate_latest(), media_type=CONTENT_TYPE_LATEST)
