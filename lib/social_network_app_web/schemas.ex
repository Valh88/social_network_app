defmodule SocialNetworkAppWeb.Schemas do
  alias OpenApiSpex.Schema
  require OpenApiSpex

  defmodule Picture do

    OpenApiSpex.schema(%{
      title: "Picture",
      description: "Description",
      type: :object,
      properties: %{
        id: %Schema{type: :ineger, description: "id"},
        name: %Schema{type: :string, description: "name picture"},
        url: %Schema{type: :string, description: "url picture"},
        inserted_at: %Schema{
          type: :string,
          description: "Creation timestamp",
          format: :"date-time"
        },
        updated_at: %Schema{type: :string, description: "Update timestamp", format: :"date-time"}
      },
      required: [:name, :url],
      example: %{
        "id" => 1,
        "name" => "Name",
        "url" => "http://exemple_url_picture.her/"
      }
    })
  end

  defmodule PictureRequest do
    OpenApiSpex.schema(%{
      title: "Pciture",
      description: "Create Pickture",
      type: :object,
      properties: %{
        picture: %Schema{anyOf: [Picture]}
      },
      required: [:picture],
      example: %{

      }
    })
  end

  defmodule User do
    OpenApiSpex.schema(%{
      title: "User",
      description: "User from app",
      type: :object,
      properties: %{
        id: %Schema{type: :string, description: "full user"},
        on_sub: %Schema{type: :integer, description: "sub_user"},
        pictures_publish: %Schema{type: :integer, description: "count picture publish"},
        to_sub: %Schema{type: :integer, description: "sub to user count"}
      },
      example: %{
        "id" => "sfsdfsdfcdasd",
        "on_sub" => 5,
        "pictures_publish" => 5,
        "to_sub" => 2,
      }
    })
  end

  defmodule UserResponse do
    OpenApiSpex.schema(%{
      title: "UserResponse",
      description: "Response schema user by id",
      type: :object,
      properties: %{
        data: User
      },
      example: %{
        "data" => %{
          "id" => "58c1b9d6-dbe9-42e4-adf1-1bc223371f50",
          "on_sub" => 0,
          "pictures_publish" => 0,
          "to_sub" => 0
        }
      },
      # "x-struct": __MODULE__
    })
  end

  defmodule UserRequest do
    OpenApiSpex.schema(%{
      title: "UserRequest",
      description: "create user registration",
      type: :object,
      properties: %{
        user: %Schema{anyOf: [User]}
      },
      required: [:user],
      example: %{
        "account" => %{
          "email" => "1@1.her",
          "password" => "ddasdasdsa"
        }
      }
    })
  end
end
