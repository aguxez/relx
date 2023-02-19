import Config

config :relx,
  ecto_repos: [Relx.Repo]

config :relx, Relx.Repo, database: "relx.db"

import_config "#{config_env()}.exs"
