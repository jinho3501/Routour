from datetime import datetime, timezone

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.core.security import get_current_uid
from app.db.session import get_db
from app.models.user import User
from app.schemas.user import UserCreate, UserOut, UserUpdate

router = APIRouter(prefix="/users", tags=["users"])


# CREATE/SYNC — 로그인 직후 호출. 없으면 만들고, 있으면 로그인 시각만 갱신
@router.post("/me/sync", response_model=UserOut)
def sync_me(
    payload: UserCreate,
    uid: str = Depends(get_current_uid),
    db: Session = Depends(get_db),
):
    user = db.get(User, uid)
    now = datetime.now(timezone.utc)

    if user is None:
        # 신규 가입 — 약관 동의도 함께 저장
        user = User(
            uid=uid,
            email=payload.email,
            display_name=payload.display_name,
            nickname=payload.nickname,
            last_login_at=now,
            tos_agreed=payload.agree_tos,
            tos_version="v1.0" if payload.agree_tos else None,
            tos_agreed_at=now if payload.agree_tos else None,
            privacy_agreed=payload.agree_privacy,
            privacy_version="v1.0" if payload.agree_privacy else None,
            privacy_agreed_at=now if payload.agree_privacy else None,
            marketing_agreed=payload.agree_marketing,
            marketing_version="v1.0" if payload.agree_marketing else None,
            marketing_agreed_at=now if payload.agree_marketing else None,
        )
        db.add(user)
    else:
        # 기존 유저 — 로그인 시각만 갱신
        user.last_login_at = now

    db.commit()
    db.refresh(user)
    return user


# READ — 내 정보 조회
@router.get("/me", response_model=UserOut)
def get_me(uid: str = Depends(get_current_uid), db: Session = Depends(get_db)):
    user = db.get(User, uid)
    if user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return user


# UPDATE — 내 정보 수정
@router.put("/me", response_model=UserOut)
def update_me(
    payload: UserUpdate,
    uid: str = Depends(get_current_uid),
    db: Session = Depends(get_db),
):
    user = db.get(User, uid)
    if user is None:
        raise HTTPException(status_code=404, detail="User not found")

    for field, value in payload.model_dump(exclude_unset=True).items():
        setattr(user, field, value)

    db.commit()
    db.refresh(user)
    return user


# DELETE — 회원 탈퇴 (본인만)
@router.delete("/me")
def delete_me(uid: str = Depends(get_current_uid), db: Session = Depends(get_db)):
    user = db.get(User, uid)
    if user is None:
        raise HTTPException(status_code=404, detail="User not found")

    db.delete(user)
    db.commit()
    return {"deleted": uid}