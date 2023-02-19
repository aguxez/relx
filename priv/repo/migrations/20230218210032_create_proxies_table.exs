defmodule Relx.Repo.Migrations.CreateProxiesTable do
  use Ecto.Migration

  def change do
    create table(:proxies) do
      add :email, :string, collate: :nocase
      add :is_enabled, :boolean
      add :user_id, references(:users)

      timestamps()
    end
  end
end
