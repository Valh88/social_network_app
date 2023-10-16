defmodule SocialNetworkApp.Users.Role do
  use Ecto.Schema
  import Ecto.Changeset
  alias SocialNetworkApp.Users.User
  alias SocialNetworkApp.Permissions

#  @primary_key {:id, :binary_id, autogenerate: true}
#  @foreign_key_type :binary_id
  schema "roles" do
    field :name, :string
    field :permissions, :map
    has_many :users, User

    timestamps()
  end

  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name, :permissions])
    |> validate_required([:name, :permissions])
    |> unique_constraint(:name)
    |> validate_at_least_one_permission()
    |> Permissions.validate_permissions(:permissions)
  end

  defp validate_at_least_one_permission(changeset) do
    validate_change(changeset, :permissions, fn field, permissions ->
      if map_size(permissions) == 0 do
        [{field, "need 1 or more perm"}]
      else
        []
      end
    end)
  end
end