defmodule SocialNetworkAppWeb.PictureJSON do
  def picture(%{picture: picture, conn: conn}) do
    %{
      id: picture.id,
      name: picture.name,
      url: Phoenix.VerifiedRoutes.static_url(conn, picture.path)
    }
  end
end
