# aws-cd-georgia-demo-app

Minimal Python Flask demo app with Dockerfile.

## Endpoints
- `/` — returns a greeting
- `/healthz` — returns `{ "status": "ok" }`

## Build
```bash
docker build -t georgia-demo-app:latest .
```

## Run locally
```bash
docker run --rm -p 8080:8080 -e PORT=8080 georgia-demo-app:latest
```

## Test
```bash
curl -s http://localhost:8080/
curl -s http://localhost:8080/healthz | jq .
```
