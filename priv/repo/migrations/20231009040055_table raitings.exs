defmodule :"Elixir.SocialNetworkApp.Repo.Migrations.Table raitings" do
  use Ecto.Migration

  def change do
    create table(:raitings) do
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :picture_id, references(:pictures, on_delete: :delete_all, type: :integer)
      add :raiting, :float

      timestamps()
    end

  end
end
