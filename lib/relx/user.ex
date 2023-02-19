defmodule Relx.User do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias Relx.Proxy

  @type t :: %__MODULE__{email: String.t(), proxies: [Proxy.t()]}

  schema "users" do
    field(:email, :string)

    has_many(:proxies, Proxy)

    timestamps()
  end

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = user, params \\ %{}) do
    user
    |> cast(params, [:email])
    |> validate_required([:email])
  end
end
