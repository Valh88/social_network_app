defmodule SocialNetworkAppWeb.Router do
  # alias SocialNetworkAppWeb.AccountController
  # alias SocialNetworkAppWeb.ProductController
  use SocialNetworkAppWeb, :router
  use Plug.ErrorHandler

  # @swagger_ui_config [
  #   path: "/api/openapi",
  #   default_model_expand_depth: 3,
  #   display_operation_id: true,
  #   oauth2_redirect_url: {:endpoint_url, "/swaggerui/oauth2-redirect.html"},
  #   oauth: [
  #     # client_id: "e2195a7487322a0f19bf"
  #     client_id: "Iv1.d7c611e5607d77b0"
  #   ]
  # ]

  def handle_errors(conn, %{reason: %Phoenix.Router.NoRouteError{message: message}}) do
    conn |> json(%{errors: message}) |> halt()
  end

  def handle_errors(conn, %{reason: %{message: message}}) do
    conn |> json(%{errors: message}) |> halt()
  end

  def handle_errors(conn, %{reason: %Maru.Params.ParseError{reason: message}}) do
    conn |> json(%{errors: message}) |> halt()
  end

  def handle_errors(conn, message) do
    IO.inspect(message)
    conn |> json(%{errors: message}) |> halt()
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug OpenApiSpex.Plug.PutApiSpec, module: SocialNetworkAppWeb.ApiSpec
  end

  pipeline :auth do
    plug SocialNetworkAppWeb.Guardian.Pipeline
    plug SocialNetworkAppWeb.Guardian.SetConnUser
  end

  pipeline :browser do
    plug :accepts, ["html"]
  end

  scope "/api" do
    pipe_through :api

    get "/openapi", OpenApiSpex.Plug.RenderSpec, []
  end

  scope "/" do
    pipe_through :browser

    get "/swag", OpenApiSpex.Plug.SwaggerUI, path: "/api/openapi"
  end

  scope "/api/users", SocialNetworkAppWeb do
    pipe_through :api

    get "/:id", AccountController, :show
    post "/register", AccountController, :create
    post "/login", AccountController, :login
  end

  scope "/api/user", SocialNetworkAppWeb do
    pipe_through [:api, :auth]

    get "/logout", AccountController, :logout
    get "/me", AccountController, :current_user

    post "/subscribe", AccountController, :subscribe
    delete "/subscribe/:id", AccountController, :unsubscribe
  end

  scope "/api/pictures", SocialNetworkAppWeb do
    pipe_through [:api, :auth]
    post "/upload", PictureController, :upload
  end

  scope "/api/pictures/:id", SocialNetworkAppWeb do
    pipe_through [:api, :auth]

    post "/raiting", RaitingController, :create
  end

  scope "/api/pictures", SocialNetworkAppWeb do
    pipe_through [:api]

    get "/", PictureController, :index
    get "/:id", PictureController, :show
    post "/add", PictureController, :create
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:social_network_app, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: SocialNetworkAppWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
