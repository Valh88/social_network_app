defmodule SocialNetworkAppWeb.PictureJSON do
  @spec picture(%{
    picture: struct(), conn: Plug.Conn.t()
    }) :: %{id: integer(), name: String.t(), url: String.t()}
  def picture(%{picture: picture, conn: conn}) do
    %{
      id: picture.id,
      name: picture.name,
      url: Phoenix.VerifiedRoutes.static_url(conn, picture.path)
    }
  end

  defp pick(pick, conn) do
    %{
      name: pick[:name],
      url: Phoenix.VerifiedRoutes.static_url(conn, pick[:path]),
      publisher: pick[:publisher]
    }
  end

  def pictures(%{pictures: pictures, conn: conn}) do
    %{data: for(pick <- pictures, do: pick(pick, conn))}
  end
end
