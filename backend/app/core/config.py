from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8")

    database_url: str = "postgresql+psycopg2://routour:routour@localhost:5432/routour"
    redis_url: str = "redis://localhost:6379/0"
    firebase_service_account_path: str = "./firebase-service-account.json"


settings = Settings()
