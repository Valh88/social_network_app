defmodule SocialNetworkAppWeb.PictureController do
  use SocialNetworkAppWeb, :controller

  alias SocialNetworkApp.Pictures

  action_fallback SocialNetworkAppWeb.FallbackController
  @format_defaut [".jpg", ".png", ".jpeg"]
  @static_url "/media/"
  @path "priv/static/media/"

  def create(conn, %{"image" => %Plug.Upload{} = upload}) do
    format = Path.extname(upload.filename)
    cond do
      format in @format_defaut ->
        upload_file(conn, format, upload)
      true ->
        {:error, :not_found}
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
      %{name: upload.filename, path: "#{@static_url}/#{user_id}/#{file_name_in_hd}"}
      ),
      :ok <- File.cp(upload.path, "#{@path}/#{user_id}/#{file_name_in_hd}") do
      conn
      |> put_status(:created)
      |> render(:picture, picture: picture, conn: conn)
    end
  end
end
