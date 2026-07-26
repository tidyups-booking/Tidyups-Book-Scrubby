import os
import uuid
from pathlib import Path
from urllib.parse import urljoin, urlparse

import requests
from pymongo import MongoClient


MONGO_URL = os.environ["MONGO_URL"]
DB_NAME = os.environ["DB_NAME"]
SOURCE_URL = os.environ["STORAGE_MIGRATION_SOURCE_URL"].rstrip("/")
STORAGE_ROOT = Path(os.environ.get("LOCAL_STORAGE_ROOT", "/data/storage"))
failures = []


def storage_path_from_url(url, prefix):
    marker = "/file/"
    if marker in url:
        return url.split(marker, 1)[1]
    suffix = Path(urlparse(url).path).suffix.lower()
    if not suffix or len(suffix) > 10:
        suffix = ".jpg"
    return f"tidyups-quote/migrated/{prefix}/{uuid.uuid4()}{suffix}"


def download(url, storage_path):
    target = (STORAGE_ROOT.resolve() / storage_path).resolve()
    if not target.is_relative_to(STORAGE_ROOT.resolve()):
        raise ValueError(f"Invalid storage path: {storage_path}")
    if target.exists():
        return

    source = url if url.startswith(("http://", "https://")) else urljoin(f"{SOURCE_URL}/", url.lstrip("/"))
    response = requests.get(source, timeout=120)
    response.raise_for_status()
    content_type = response.headers.get("Content-Type", "").lower()
    data = response.content
    looks_like_image = (
        data.startswith(b"\xff\xd8\xff")
        or data.startswith(b"\x89PNG\r\n\x1a\n")
        or data.startswith((b"GIF87a", b"GIF89a"))
        or (data.startswith(b"RIFF") and data[8:12] == b"WEBP")
    )
    if not content_type.startswith("image/") and not looks_like_image:
        raise ValueError(f"Source did not return an image ({content_type or 'unknown content type'})")
    target.parent.mkdir(parents=True, exist_ok=True)
    temporary = target.with_suffix(f"{target.suffix}.tmp")
    temporary.write_bytes(data)
    temporary.replace(target)


def migrate_image_collection(collection, prefix):
    migrated = 0
    for doc in collection.find({"url": {"$type": "string", "$ne": ""}}):
        storage_path = doc.get("storage_path") or storage_path_from_url(doc["url"], prefix)
        try:
            download(doc["url"], storage_path)
            local_url = f"/api/{prefix}-images/file/{storage_path}"
            collection.update_one(
                {"_id": doc["_id"]},
                {"$set": {"storage_path": storage_path, "url": local_url}},
            )
            migrated += 1
        except Exception as exc:
            failures.append(f"{collection.name} {doc['_id']}: {exc}")
    return migrated


def migrate_assignment_photos(collection):
    migrated = 0
    for assignment in collection.find({"photos.0": {"$exists": True}}):
        photos = assignment.get("photos", [])
        changed = False
        for photo in photos:
            url = photo.get("url")
            if not url:
                continue
            storage_path = photo.get("storage_path") or storage_path_from_url(url, "proof")
            try:
                download(url, storage_path)
                photo["storage_path"] = storage_path
                photo["url"] = f"/api/app-images/file/{storage_path}"
                migrated += 1
                changed = True
            except Exception as exc:
                failures.append(f"assignment {assignment['_id']} photo {photo.get('id', 'unknown')}: {exc}")
        if changed:
            collection.update_one({"_id": assignment["_id"]}, {"$set": {"photos": photos}})
    return migrated


def migrate_logo(collection):
    doc = collection.find_one({"key": "business", "logo_url": {"$type": "string", "$ne": ""}})
    if not doc:
        return 0
    storage_path = doc.get("logo_storage_path") or storage_path_from_url(doc["logo_url"], "logo")
    try:
        download(doc["logo_url"], storage_path)
        collection.update_one(
            {"_id": doc["_id"]},
            {"$set": {
                "logo_storage_path": storage_path,
                "logo_url": f"/api/app-images/file/{storage_path}",
            }},
        )
        return 1
    except Exception as exc:
        failures.append(f"business logo {doc['_id']}: {exc}")
        return 0


def main():
    STORAGE_ROOT.mkdir(parents=True, exist_ok=True)
    client = MongoClient(MONGO_URL)
    database = client[DB_NAME]
    expected = {"quotes", "site_images", "app_images", "assignments", "app_settings"}
    if not expected.intersection(database.list_collection_names()):
        client.close()
        raise RuntimeError(f"No application collections found in database {DB_NAME!r}")
    counts = {
        "site images": migrate_image_collection(database.site_images, "site"),
        "app images": migrate_image_collection(database.app_images, "app"),
        "assignment photos": migrate_assignment_photos(database.assignments),
        "business logos": migrate_logo(database.app_settings),
    }
    client.close()
    print(", ".join(f"{name}: {count}" for name, count in counts.items()))
    if failures:
        print("Migration failures:")
        for failure in failures:
            print(f"- {failure}")
        raise SystemExit(1)


if __name__ == "__main__":
    main()
