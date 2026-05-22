import os
import pymysql
from flask import Flask, render_template

app = Flask(__name__)

DB_HOST = os.getenv("DB_HOST", "")
DB_PORT = int(os.getenv("DB_PORT", "3306"))
DB_NAME = os.getenv("DB_NAME", "appdb")
DB_USER = os.getenv("DB_USER", "appuser")
DB_PASSWORD = os.getenv("DB_PASSWORD", "")

def check_db():
    try:
        conn = pymysql.connect(
            host=DB_HOST,
            port=DB_PORT,
            user=DB_USER,
            password=DB_PASSWORD,
            database=DB_NAME,
            connect_timeout=5,
            cursorclass=pymysql.cursors.DictCursor
        )
        with conn.cursor() as cur:
            cur.execute("SELECT VERSION() AS version")
            row = cur.fetchone()
        conn.close()
        return True, row["version"]
    except Exception as e:
        return False, str(e)

@app.route("/")
def index():
    ok, info = check_db()
    return render_template(
        "index.html",
        db_host=DB_HOST,
        db_name=DB_NAME,
        db_user=DB_USER,
        db_ok=ok,
        db_info=info
    )

@app.route("/health")
def health():
    ok, _ = check_db()
    return {"status": "ok" if ok else "fail"}, 200 if ok else 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
