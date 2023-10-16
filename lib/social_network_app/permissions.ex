defmodule SocialNetworkApp.Permissions do
  import Ecto.Changeset

  def all() do
    %{
      "pictures" => ["create", "read", "update", "delete"],
      "comments" => ["create", "read", "update", "delete"],
      "users" => ["create", "read", "update", "delete"],
      "raitings" => ["create", "read", "update", "delete"]
    }
  end

  def validate_permissions(changeset, field) do
    validate_change(changeset, field, fn _field, permissions ->
      permissions
      |> Enum.reject(&has_permission?(all(), &1))
      |> case do
           [] -> []
           invalid_permissions -> [{field, {"invalid permissions", invalid_permissions}}]
         end
    end)
  end

  def has_permission?(permissions, {name, actions}) do
    exists?(name, permissions) && actions_valid?(name, actions, permissions)
  end

  defp exists?(name, permissions), do: Map.has_key?(permissions, name)

  defp actions_valid?(permission_name, given_action, permissions) when is_binary(given_action) do
    actions_valid?(permission_name, [given_action], permissions)
  end

  defp actions_valid?(permission_name, given_actions, permissions) when is_list(given_actions) do
    defined_actions = Map.get(permissions, permission_name)
    Enum.all?(given_actions, &(&1 in defined_actions))
  end

  def user_has_permissions?(user, permission) do
#    if actions in user.role.permissions[name] do
#      true
#    end
    has_permission?(user.role.permissions, {name, actions} = permission)
  end
end