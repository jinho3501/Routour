from fastapi import FastAPI

from app.api.routes import users

app = FastAPI(title="Routour API")

app.include_router(users.router)


@app.get("/health")
def health():
    return {"status": "ok"}
