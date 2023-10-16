defmodule SocialNetworkApp.Roles do
  import Ecto.Changeset
  alias SocialNetworkApp.Users.Role
  alias SocialNetworkApp.Repo

  def default_roles() do
    [
      %{
        name: "Super User",
        permissions: %{
          "pictures" => ["create", "read", "update", "delete"],
          "comments" => ["create", "read", "update", "delete"],
          "users" => ["create", "read", "update", "delete"],
          "raitings" => ["create", "read", "update", "delete"],
        }
      },
      %{
        name: "Admin",
        permissions: %{
          "pictures" => ["create", "read", "update"],
          "comments" => ["create", "read", "update"],
          "users" => ["read", "update", "delete"],
          "raitings" => ["create", "read", "update"]
        }
      },
      %{
        name: "Just user",
        permissions: %{
          "pictures" => ["create", "read"],
          "comments" => ["create", "read"],
          "raitings" => ["create", "read"]
        }
      }
    ]
  end

  def create_role(attrs) do
    %Role{}
    |> Role.changeset(attrs)
    |> Repo.insert()
  end

  def get_role_by_name(name) do
    Repo.get_by(Role, name: name)
  end
end