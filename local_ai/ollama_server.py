import json
import os
import urllib.error
import urllib.request
from http.server import BaseHTTPRequestHandler, HTTPServer


HOST = "127.0.0.1"
PORT = 8000


def load_env_file(path: str):
    if not os.path.exists(path):
        return

    with open(path, "r", encoding="utf-8") as f:
        for raw_line in f:
            line = raw_line.strip()
            if not line or line.startswith("#") or "=" not in line:
                continue

            key, value = line.split("=", 1)
            key = key.strip()
            value = value.strip()

            if key and key not in os.environ:
                os.environ[key] = value


CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
load_env_file(os.path.join(CURRENT_DIR, ".env"))


APPWRITE_ENDPOINT = os.getenv("APPWRITE_ENDPOINT", "http://127.0.0.1/v1").rstrip("/")
APPWRITE_PROJECT_ID = os.getenv("APPWRITE_PROJECT_ID", "")
APPWRITE_DATABASE_ID = os.getenv("APPWRITE_DATABASE_ID", "community")
APPWRITE_API_KEY = os.getenv("APPWRITE_API_KEY", "")

OLLAMA_URL = os.getenv("OLLAMA_URL", "http://127.0.0.1:11434/api/chat")
OLLAMA_MODEL = os.getenv("OLLAMA_MODEL", "qwen3.5:4b")


EVENTS_COLLECTION_ID = "events"
ANNOUNCEMENTS_COLLECTION_ID = "announcements"


def http_post_json(url: str, payload: dict, headers: dict | None = None) -> dict:
    req_headers = {"Content-Type": "application/json"}
    if headers:
        req_headers.update(headers)

    req = urllib.request.Request(
        url,
        data=json.dumps(payload).encode("utf-8"),
        headers=req_headers,
        method="POST",
    )

    with urllib.request.urlopen(req, timeout=120) as response:
        return json.loads(response.read().decode("utf-8"))


def http_get_json(url: str, headers: dict | None = None) -> dict:
    req = urllib.request.Request(
        url,
        headers=headers or {},
        method="GET",
    )

    try:
        with urllib.request.urlopen(req, timeout=120) as response:
            return json.loads(response.read().decode("utf-8"))
    except urllib.error.HTTPError as e:
        error_body = e.read().decode("utf-8", errors="replace")
        print(f"DEBUG HTTPError status: {e.code}")
        print(f"DEBUG HTTPError body: {error_body}")
        raise


def build_appwrite_headers() -> dict:
    headers = {
        "X-Appwrite-Project": APPWRITE_PROJECT_ID,
        "Content-Type": "application/json",
    }

    if APPWRITE_API_KEY:
        headers["X-Appwrite-Key"] = APPWRITE_API_KEY

    return headers


def list_collection_documents(collection_id: str, limit: int = 5) -> list[dict]:
    url = (
        f"{APPWRITE_ENDPOINT}/databases/{APPWRITE_DATABASE_ID}"
        f"/collections/{collection_id}/documents"
    )

    print(f"DEBUG Appwrite URL: {url}")
    print(f"DEBUG Project ID set: {bool(APPWRITE_PROJECT_ID)}")
    print(f"DEBUG API key set: {bool(APPWRITE_API_KEY)}")
    print(f"DEBUG Collection ID: {collection_id}")

    data = http_get_json(url, headers=build_appwrite_headers())
    documents = data.get("documents", [])

    return documents[:limit]


def safe_get(doc: dict, *keys: str) -> str:
    for key in keys:
        value = doc.get(key)
        if value is not None and str(value).strip():
            return str(value).strip()
    return ""


def get_latest_events(limit: int = 5) -> list[dict]:
    return list_collection_documents(EVENTS_COLLECTION_ID, limit=limit)


def get_latest_announcements(limit: int = 5) -> list[dict]:
    return list_collection_documents(ANNOUNCEMENTS_COLLECTION_ID, limit=limit)


def format_events_context(events: list[dict]) -> str:
    if not events:
        return "No events available."

    lines = []
    for event in events:
        title = safe_get(event, "title_en", "titleEn", "title")
        location = safe_get(event, "location_en", "locationEn", "location")
        date = safe_get(event, "date")
        time = safe_get(event, "time")
        details = safe_get(event, "details_en", "detailsEn", "details")

        lines.append(
            f"- Title: {title or 'Unknown'} | Date: {date or 'Unknown'} | "
            f"Time: {time or 'Unknown'} | Location: {location or 'Unknown'} | "
            f"Details: {details or 'No details'}"
        )

    return "\n".join(lines)


def format_announcements_context(announcements: list[dict]) -> str:
    if not announcements:
        return "No announcements available."

    lines = []
    for item in announcements:
        title = safe_get(item, "title_en", "titleEn", "title")
        details = safe_get(item, "details_en", "detailsEn", "details", "description")

        lines.append(
            f"- Title: {title or 'Unknown'} | Details: {details or 'No details'}"
        )

    return "\n".join(lines)


def build_context() -> str:
    try:
        events = get_latest_events(limit=6)
    except Exception as e:
        events = []
        print(f"Failed to fetch events: {e}")

    try:
        announcements = get_latest_announcements(limit=6)
    except Exception as e:
        announcements = []
        print(f"Failed to fetch announcements: {e}")

    events_text = format_events_context(events)
    announcements_text = format_announcements_context(announcements)

    return (
        "APP DATA CONTEXT\n"
        "Latest Events:\n"
        f"{events_text}\n\n"
        "Latest Announcements:\n"
        f"{announcements_text}\n"
    )


def ask_ollama(user_message: str) -> str:
    context_block = build_context()

    payload = {
        "model": OLLAMA_MODEL,
        "messages": [
            {
                "role": "system",
                "content": (
                    "You are a helpful assistant for a University of Oulu student community app. "
                    "This app focuses on events, activities, announcements, community posts, and student engagement. "
                    "Do not mention courses, course schedules, or academic advising unless the user explicitly asks about them. "
                    "Use the provided app data context when answering. "
                    "If the answer is not available in the context, say that clearly instead of inventing information. "
                    "Keep answers useful, clear, and fairly short."
                ),
            },
            {
                "role": "system",
                "content": context_block,
            },
            {
                "role": "user",
                "content": user_message,
            },
        ],
        "stream": False,
    }

    data = http_post_json(OLLAMA_URL, payload)
    return data.get("message", {}).get("content", "No response from model.")


class Handler(BaseHTTPRequestHandler):
    def _send_json(self, status_code: int, body: dict):
        self.send_response(status_code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Headers", "Content-Type")
        self.send_header("Access-Control-Allow-Methods", "POST, OPTIONS")
        self.end_headers()
        self.wfile.write(json.dumps(body).encode("utf-8"))

    def do_OPTIONS(self):
        self._send_json(200, {"ok": True})

    def do_POST(self):
        if self.path != "/chat":
            self._send_json(404, {"error": "Not found"})
            return

        try:
            content_length = int(self.headers.get("Content-Length", "0"))
            raw = self.rfile.read(content_length)
            payload = json.loads(raw.decode("utf-8"))

            message = payload.get("message", "").strip()
            if not message:
                self._send_json(400, {"error": "message is required"})
                return

            reply = ask_ollama(message)
            self._send_json(200, {"response": reply})
        except Exception as e:
            self._send_json(500, {"error": str(e)})


if __name__ == "__main__":
    if not APPWRITE_PROJECT_ID:
        print("Warning: APPWRITE_PROJECT_ID is empty.")
    if not APPWRITE_API_KEY:
        print("Warning: APPWRITE_API_KEY is empty. This may fail if your collection permissions are restricted.")

    print(f"Using Appwrite endpoint: {APPWRITE_ENDPOINT}")
    print(f"Using database: {APPWRITE_DATABASE_ID}")
    print(f"Using Ollama model: {OLLAMA_MODEL}")

    server = HTTPServer((HOST, PORT), Handler)
    print(f"Local AI server running at http://{HOST}:{PORT}")
    server.serve_forever()
