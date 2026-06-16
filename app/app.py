import os
import sqlite3

from flask import Flask
from flask import jsonify
from flask import request
from flask import send_from_directory

BASE_DIR = os.path.dirname(__file__)

DB_PATH = os.path.join(BASE_DIR, "armageddon.db")

if not os.path.exists(DB_PATH):
    import init_db

app = Flask(
    __name__,
    static_folder="static"
)


@app.route("/")
def index():
    return send_from_directory(app.static_folder, "index.html")


@app.route("/api/login", methods=["POST"])
def login():

    data = request.get_json()

    conn = sqlite3.connect(DB_PATH)
    cur = conn.cursor()

    cur.execute(
        "SELECT * FROM users WHERE username=? AND password=?",
        (data["username"], data["password"])
    )

    result = cur.fetchone()

    conn.close()

    if result:
        return jsonify({"success": True})

    return jsonify({"success": False}), 401


@app.route("/<path:path>")
def assets(path):
    return send_from_directory(app.static_folder, path)


app.run(
    host="0.0.0.0",
    port=8080
)