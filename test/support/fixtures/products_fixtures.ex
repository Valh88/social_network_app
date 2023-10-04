defmodule SocialNetworkApp.ProductsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SocialNetworkApp.Products` context.
  """

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> SocialNetworkApp.Products.create_product()

    product
  end
end
