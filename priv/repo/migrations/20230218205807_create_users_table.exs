defmodule Relx.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, collate: :nocase

      timestamps()
    end
  end
end
