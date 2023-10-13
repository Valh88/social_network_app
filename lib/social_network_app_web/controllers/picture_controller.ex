defmodule SocialNetworkAppWeb.PictureController do
  use SocialNetworkAppWeb, :controller
  use Maru.Params.PhoenixController

  alias SocialNetworkApp.Pictures.PictureUserAssoc
  alias SocialNetworkApp.Pictures.Picture
  alias SocialNetworkApp.Pictures

  action_fallback SocialNetworkAppWeb.FallbackController
  @format_defaut [".jpg", ".png", ".jpeg"]
  @static_url "/media/"
  @path "priv/static/media/"
  @limit_default 8
  @offset_default 1

  @spec upload(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def upload(conn, %{"image" => %Plug.Upload{} = upload}) do
    format = Path.extname(upload.filename)
    cond do
      format in @format_defaut ->
        upload_file(conn, format, upload)
      true ->
        {:error, :not_found}
    end
  end

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    check_pick = fn id ->
      case Pictures.get_picture_by_id(id) do
        %Picture{} = user -> user
        nil -> {:error, :not_found}
      end
    end

    with %Picture{} = picture <- check_pick.(id) do
      conn
      |> put_status(:ok)
      |> render(:picture, picture: picture)
    end
  end

  params :index do
    optional :limit, Integer
    optional :page, Integer
  end

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, param) do
    check_param = fn par ->
      case par do
        %{limit: limit, page: page} -> [limit: limit, offset: page]
        %{limit: limit} -> [limit: limit, offset: @offset_default]
        %{page: page} -> [limit: @limit_default, offset: page]
        _ -> [limit: @limit_default, offset: @offset_default]
      end
    end

    with pictures <- Pictures.get_pick_all(check_param.(param)) do
      conn
      |> put_status(:created)
      |> render(:pictures, pictures: pictures, conn: conn)
    end
  end

  defp upload_file(conn, format_file, upload) do
    user_id = conn.assigns[:current_user].id
    unless File.exists?("#{@path}/#{user_id}")  do
      File.mkdir("#{@path}/#{user_id}")
    end

    uuid =  Ecto.UUID.generate
    file_name_in_hd = "#{uuid}#{format_file}"
    with {:ok, picture} <- Pictures.save_picture(
      %{name: upload.filename, path: "#{@static_url}#{user_id}/#{file_name_in_hd}"}
      ),
      {:ok, %PictureUserAssoc{} = _assoc} <- Pictures.save_assoc_picture_to_user(
        %{user_id: user_id, picture_id: picture.id}
      ),
      :ok <- File.cp(upload.path, "#{@path}/#{user_id}/#{file_name_in_hd}") do
      conn
      |> put_status(:created)
      |> render(:picture, picture: picture, conn: conn)
    end
  end
end
