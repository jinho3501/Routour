import firebase_admin
from fastapi import Header, HTTPException, status
from firebase_admin import auth as firebase_auth
from firebase_admin import credentials

from app.core.config import settings

_cred = credentials.Certificate(settings.firebase_service_account_path)
firebase_admin.initialize_app(_cred)


async def get_current_uid(authorization: str = Header(...)) -> str:
    """Verify the Firebase ID token sent as 'Authorization: Bearer <token>' and
    return the Firebase uid. Flutter attaches the token from
    FirebaseAuth.instance.currentUser.getIdToken() to every request.
    """
    if not authorization.startswith("Bearer "):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Missing or malformed Authorization header",
        )

    id_token = authorization.removeprefix("Bearer ").strip()

    try:
        decoded = firebase_auth.verify_id_token(id_token)
    except Exception as exc:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired Firebase ID token",
        ) from exc

    return decoded["uid"]
