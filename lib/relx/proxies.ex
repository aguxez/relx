defmodule Relx.Proxies do
  @moduledoc "Proxies context"

  alias Relx.Proxy
  alias Relx.Repo

  @spec get_by_email(String.t()) :: Proxy.t() | nil
  def get_by_email(email) do
    Repo.get_by(Proxy, email: email)
  end
end
