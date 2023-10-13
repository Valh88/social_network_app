defmodule SocialNetworkApp.Users.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias SocialNetworkApp.Users.User
  alias SocialNetworkApp.Accounts.Account
  alias SocialNetworkApp.Pictures.{Raiting, Picture}
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "users" do
    belongs_to :account, Account
    many_to_many :pictures, SocialNetworkApp.Pictures.Picture,
      join_through: "pictures_users"
    #Self-referencing many to many
    many_to_many :subscribe_on, User,
      join_through: SocialNetworkApp.Users.Subscribe,
      join_keys: [subscriber_id: :id, on_sub_id: :id]
    many_to_many :subscribe_self, User,
      join_through: SocialNetworkApp.Users.Subscribe,
      join_keys: [subscriber_id: :id, on_sub_id: :id]
    many_to_many :raiting_add_to, Picture,
      join_through: Raiting

    timestamps()
  end

  @spec changeset(struct(), map()) :: Ecto.Changeset.t()
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:account_id])
    |> validate_required([:account_id])
    |> unique_constraint(:account_id)
  end
end
