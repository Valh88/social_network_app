defmodule SocialNetworkAppWeb.RaitingController do
  use SocialNetworkAppWeb, :controller
  use Maru.Params.PhoenixController

  alias SocialNetworkApp.Pictures
  alias SocialNetworkApp.Pictures.Raiting
  alias SocialNetworkApp.Pictures.Picture

  @permission_default actions: [
                        create: {"raitings", "create"},
                      ]
  action_fallback SocialNetworkAppWeb.FallbackController
  plug(SocialNetworkAppWeb.Guardian.Permissions.CheckPerm, @permission_default)

  params :create do
    requires :id, Integer
    requires :raiting, Float
  end

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, params) do
    user = conn.assigns[:current_user]
    with %Picture{} = picture <- Pictures.get_picture_by_id(params[:id]),
      nil <- Pictures.check_if_not_exist(user, picture),
      {:ok, %Raiting{} = rating}  <- Pictures.add_raiting_from_user_to_picture(
        picture, user, params[:raiting]) do
    conn
    |> put_status(:ok)
    |> render(:raiting, raiting: rating)
    else
      {:error, raiting} ->
        conn
        |> put_status(:forbidden)
        |> json(%{errors: %{detail: "add raiting already -- #{raiting.raiting}"}})
      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, changeset}
    end
  end
end
