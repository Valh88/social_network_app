defmodule SocialNetworkAppWeb.CommentController do
  use SocialNetworkAppWeb, :controller
  use Maru.Params.PhoenixController
  alias SocialNetworkApp.Pictures
  alias SocialNetworkApp.Comments
  alias SocialNetworkApp.Comments.Comment
  alias SocialNetworkApp.Pictures.Picture
  import SocialNetworkAppWeb.Guardian.Permissions.CheckUserContent

  action_fallback SocialNetworkAppWeb.FallbackController

  @offset_default 1
  @limit_default 8

  @permission_default actions: [
    create: {"comments", "create"},
    index: {"comments", "read"},
    delete: {"comments", "delete"}
  ]

  plug SocialNetworkAppWeb.Guardian.Permissions.CheckPerm, @permission_default when action in [:create, :index]
  plug :if_user_has_same_id when action in [:delete]

  params(:create) do
    requires :id, Integer
    requires :comment, Map do
      optional :text, String
    end
  end

  def create(conn, params) do
    %{comment: comment, id: id} = params
    current_user = conn.assigns[:current_user]
    with %Picture{} = _picture <- Pictures.get_picture_by_id(id),
      {:ok, comment} <- Comments.create_comment(%{
        picture_id: id, user_id: current_user.id, text: comment[:text]
      }) do
      conn
      |> put_status(:ok)
      |> render(:comment, comment: comment)
    else
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{errors: %{detail: "picture not found"}})
      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, changeset}
    end
  end

  params :index do
    requires :id, Integer
    optional :limit, Integer
    optional :page, Integer
  end

  def index(conn, params) do
    check_param = fn par ->
      case par do
        %{id: _, limit: limit, page: page} -> [limit: limit, offset: page]
        %{id: _, limit: limit} -> [limit: limit, offset: @offset_default]
        %{id: _, page: page} -> [limit: @limit_default, offset: page]
        _ -> [limit: @limit_default, offset: @offset_default]
      end
    end
    with %Picture{} = _picture <- Pictures.get_picture_by_id(params[:id]),
      comments <- Comments.get_comments(params[:id], check_param.(params)) do
      conn
      |> put_status(:ok)
      |> render(:comments, comments: comments)
    else
      nil ->
        {:error, :not_found}
    end
  end

  params :delete do
    requires :id, Integer
  end

  def delete(conn, params) do
    with {:ok, _c} <- Comments.delete_comment(conn.assigns[:comment]) do
      conn
      |> send_resp(:no_content, "")
    else
      nil ->
        {:error, :not_found}
    end
  end
end
