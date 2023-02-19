import Config

config :relx,
  ecto_repos: [Relx.Repo]

import_config "#{config_env()}.exs"
