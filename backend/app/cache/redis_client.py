import json
from typing import Any

import redis

from app.core.config import settings

redis_client = redis.Redis.from_url(settings.redis_url, decode_responses=True)

DEFAULT_TTL_SECONDS = 60 * 60 * 24  # TourAPI 응답은 하루 단위로 캐싱


def get_cached_json(key: str) -> Any | None:
    raw = redis_client.get(key)
    return json.loads(raw) if raw is not None else None


def set_cached_json(key: str, value: Any, ttl_seconds: int = DEFAULT_TTL_SECONDS) -> None:
    redis_client.set(key, json.dumps(value), ex=ttl_seconds)


def make_tour_api_cache_key(endpoint: str, **params: Any) -> str:
    sorted_params = "&".join(f"{k}={v}" for k, v in sorted(params.items()))
    return f"tourapi:{endpoint}:{sorted_params}"
