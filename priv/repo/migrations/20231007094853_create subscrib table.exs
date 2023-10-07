defmodule :"Elixir.SocialNetworkApp.Repo.Migrations.Create subscrib table" do
  use Ecto.Migration

  def change do
    create table(:subscriptions) do
      add :subscriber_id, references(:users, type: :binary_id)
      add :on_sub_id, references(:users, type: :binary_id)

      timestamps()
    end
  end
end
