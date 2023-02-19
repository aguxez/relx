import Config

config :relx, Relx.Repo, database: System.fetch_env!("DATABASE_PATH")
