import Config

config :relx, Relx.Repo, database: System.get_env("DATABASE_PATH") || "relx.db"
