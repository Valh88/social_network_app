defmodule SocialNetworkApp.Repo.Migrations.CreatePickUserAssoc do
  use Ecto.Migration

  def change do
    create table(:pictures_users) do
      add :user_id, references(:users, type: :binary_id)
      add :picture_id, references(:pictures)

      timestamps()
    end
  end

  # create index(:pictures_users, :puplisher_id)
  # create index(:pictures_users, :picture_id)
end
