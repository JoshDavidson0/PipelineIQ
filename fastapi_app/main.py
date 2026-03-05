from fastapi import FastAPI, Query
from typing import List, Optional
from database import get_connection
from models import Upload, UploadSummary, Label

app = FastAPI()

@app.get("/uploads", response_model=List[UploadSummary])
def get_uploads(tag: Optional[str] = Query(default=None)):
    conn = get_connection()
    cur = conn.cursor()

    if tag:
        cur.execute("""
            SELECT DISTINCT u.id, u.filename, u.uploaded_at
            FROM uploads u
            JOIN results r ON r.upload_id = u.id
            WHERE LOWER(r.label) = LOWER(%s)
        """, (tag,))
    else:
        cur.execute("SELECT id, filename, uploaded_at FROM uploads")

    uploads = cur.fetchall()
    conn.close()
    return uploads

@app.get("/uploads/{upload_id}", response_model=Upload)
def get_upload(upload_id: int):
    conn = get_connection()
    cur = conn.cursor()

    cur.execute("SELECT * FROM uploads WHERE id = %s", (upload_id,))
    upload = cur.fetchone()

    cur.execute("SELECT * FROM results WHERE upload_id = %s", (upload_id,))
    labels = cur.fetchall()

    conn.close()

    upload["labels"] = labels
    return upload

