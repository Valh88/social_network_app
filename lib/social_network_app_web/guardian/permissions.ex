defmodule SocialNetworkAppWeb.Guardian.Permissions do
  import Plug.Conn
  import Phoenix.Controller, only: [action_name: 1]
  alias SocialNetworkApp.Permissions
  alias SocialNetworkApp.Repo
  alias SocialNetworkAppWeb.Guardian.ErrorResponsePlug

  defmodule CheckPerm do
    def init(opts), do: opts

    def call(conn, opts) do
      user = get_current_user(conn)
      required_permission = get_required_permission(conn, opts)

      if Permissions.user_has_permissions?(user, required_permission) do
        conn
      else
        raise ErrorResponsePlug.Forbidden
      end
      conn
    end

    defp get_current_user(conn) do
      conn.assigns[:current_user]
      |> Repo.preload(:role)
    end

    defp get_required_permission(conn, opts) do
      action = action_name(conn)
      opts
      |> Keyword.fetch!(:actions)
      |> Keyword.fetch!(action)
    end
  end
end
