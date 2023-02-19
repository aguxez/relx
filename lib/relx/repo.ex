defmodule Relx.Repo do
  @moduledoc false

  use Ecto.Repo, otp_app: :relx, adapter: Ecto.Adapters.SQLite3
end
