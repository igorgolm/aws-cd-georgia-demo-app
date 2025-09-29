import os
from flask import Flask, jsonify


def create_app() -> Flask:
    app = Flask(__name__)

    @app.get("/")
    def index():
        return "Hello from AWS CD Georgia!", 200

    @app.get("/healthz")
    def healthz():
        return jsonify(status="ok"), 200

    return app

app = create_app()

if __name__ == "__main__":
    port = int(os.getenv("PORT", "8080"))
    app.run(host="0.0.0.0", port=port)


