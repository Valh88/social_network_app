defmodule SocialNetworkAppWeb.ProductController do
  use SocialNetworkAppWeb, :controller

  alias SocialNetworkApp.Products
  alias SocialNetworkApp.Products.Product

  action_fallback SocialNetworkAppWeb.FallbackController

  def index(conn, _params) do
    products = Products.list_products()
    render(conn, :index, products: products)
  end

  def create(conn, %{"product" => %Plug.Upload{} = upload}) do
    IO.inspect(upload)
    extension = Path.extname(upload.filename)
    IO.inspect(extension)
    File.cp(upload.path, "priv/static/media/cover#{extension}")
    # with {:ok, %Product{} = product} <- Products.create_product(product_params) do
    #   conn
    #   |> put_status(:created)
    #   |> put_resp_header("location", ~p"/api/products/#{product}")
    #   |> render(:show, product: product)
    # end
  end

  @spec show(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    product = Products.get_product!(id)
    render(conn, :show, product: product)
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    product = Products.get_product!(id)

    with {:ok, %Product{} = product} <- Products.update_product(product, product_params) do
      render(conn, :show, product: product)
    end
  end

  def delete(conn, %{"id" => id}) do
    product = Products.get_product!(id)

    with {:ok, %Product{}} <- Products.delete_product(product) do
      send_resp(conn, :no_content, "")
    end
  end
end
