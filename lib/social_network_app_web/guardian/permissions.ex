defmodule SocialNetworkAppWeb.Guardian.Permissions do
  import Plug.Conn
  import Phoenix.Controller, only: [action_name: 1]
  alias SocialNetworkApp.Comments
  alias SocialNetworkApp.Comments.Comment
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


  defmodule CheckUserContent do
    def if_user_has_same_id(conn, _opts) do
      %{params: %{"id" => id}} = conn
      user = conn.assigns[:current_user]
      with %Comment{} = comment <- Comments.get_comment_by_id(id) do
        if comment.user_id == user.id do
          conn
          |> assign(:comment, comment)
        else
          raise ErrorResponsePlug.Forbidden
        end
      else
        nil ->
          raise ErrorResponsePlug.NotFound
      end
    end
  end
end
