defmodule :"Elixir.SocialNetworkApp.Repo.Migrations.Roles table" do
  use Ecto.Migration

  def change do
    create table(:roles) do
#      add :id, :binary_id, primary_key: true
      add :name, :string
      add :permissions, :map

      timestamps()
    end

    alter table(:users) do
      add :role_id, references(:roles, on_delete: :nothing, type: :integer)
    end
  end
end
