defmodule Relx.Proxy do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias Relx.User

  @type t :: %__MODULE__{email: String.t(), user: User.t()}

  schema "proxies" do
    field(:email, :string)
    field(:is_enabled, :boolean, default: true)

    belongs_to(:user, User)

    timestamps()
  end

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = proxy, params \\ %{}) do
    proxy
    |> cast(params, [:email, :user_id])
    |> validate_required([:email, :user_id])
  end
end
