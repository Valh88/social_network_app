defmodule SocialNetworkApp.Repo.Migrations.CreatPickTable do
  use Ecto.Migration

  def change do
    # create table(:pictures, primary_key: false) do
    create table(:pictures) do
      # add :id, :binary_id, primary_key: true
      add :name, :string
      add :path, :string

      timestamps()
    end
  end
end
