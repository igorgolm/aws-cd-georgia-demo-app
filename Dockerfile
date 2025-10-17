# syntax=docker/dockerfile:1.7
FROM python:3.10-alpine3.13

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=8080 \
    GUNICORN_WORKERS=2 \
    GUNICORN_THREADS=8

WORKDIR /app

# Install runtime dependencies
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --upgrade pip

# Install Python dependencies first for better layer caching
COPY requirements.txt ./
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Use a non-root user for security
RUN addgroup -S appuser && adduser -S appuser -G appuser
USER appuser

EXPOSE 8080

# Gunicorn entrypoint
CMD ["sh","-lc","gunicorn -w ${GUNICORN_WORKERS} -k gthread --threads ${GUNICORN_THREADS} -b 0.0.0.0:${PORT} app:app"]