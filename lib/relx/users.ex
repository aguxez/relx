defmodule Relx.Users do
  @moduledoc "Users context"

  alias Relx.Repo
  alias Relx.User

  @spec get_by_id(non_neg_integer()) :: User.t() | nil
  def get_by_id(user_id) do
    Repo.get(User, user_id)
  end
end
