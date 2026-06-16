import sqlite3

conn = sqlite3.connect("armageddon.db")

cur = conn.cursor()

cur.execute("""
CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY,
    username TEXT,
    password TEXT
)
""")

cur.execute("""
INSERT OR IGNORE INTO users
VALUES (1, 'admin', 'admin')
""")

conn.commit()
conn.close()