defmodule :"Elixir.SocialNetworkApp.Repo.Migrations.Comments for pictures" do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :picture_id, references(:pictures, on_delete: :delete_all, type: :integer)
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :text, :string

      timestamps()
    end
  end
end
