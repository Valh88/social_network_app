defmodule SocialNetworkApp.Users.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias SocialNetworkApp.Pictures
  alias SocialNetworkApp.Accounts.Account
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    belongs_to :account, Account
    many_to_many :pictures, SocialNetworkApp.Pictures.Picture,
      join_through: "pictures_users"
      
    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:account_id])
    |> validate_required([:account_id])
    |> unique_constraint(:account_id)
  end
end
