# syntax=docker/dockerfile:1.7
FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=8080 \
    GUNICORN_WORKERS=2 \
    GUNICORN_THREADS=8

WORKDIR /app

# Install runtime dependencies
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --upgrade pip

# Add build deps required for compiling some Python packages (e.g., Pillow)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    zlib1g-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libtiff5-dev && \
    rm -rf /var/lib/apt/lists/*

# Install Python dependencies first for better layer caching
COPY requirements.txt ./
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Intentionally add vulnerable packages for demo security scans
# Note: these are not used by the app
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --no-cache-dir "Pillow==9.0.0" "urllib3==1.25.8"

# Use a non-root user for security
RUN useradd -m appuser && chown -R appuser:appuser /app
USER appuser

EXPOSE 8080

# Gunicorn entrypoint
CMD ["sh","-lc","gunicorn -w ${GUNICORN_WORKERS} -k gthread --threads ${GUNICORN_THREADS} -b 0.0.0.0:${PORT} app:app"]


