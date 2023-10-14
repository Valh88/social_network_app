defmodule SocialNetworkAppWeb.ApiSpec do
  alias OpenApiSpex.{Components, Info, OpenApi, Paths, Server, SecurityScheme}
  alias SocialNetworkAppWeb.{Endpoint, Router}
  @behaviour OpenApi

  @impl OpenApi
  def spec do
    %OpenApi{
      servers: [
        Server.from_endpoint(Endpoint)
      ],
      info: %Info{
        title: "Just app",
        version: "1.0"
      },
      paths: Paths.from_router(Router),
      components: %Components{
        securitySchemes: %{
          "authorization" => %SecurityScheme{type: "http", scheme: "bearer"}
        }
      },
      security: [
        %{"authorization" => []}
      ]
    }
    |> OpenApiSpex.resolve_schema_modules()
  end
end
