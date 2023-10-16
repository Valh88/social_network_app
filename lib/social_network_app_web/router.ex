defmodule SocialNetworkAppWeb.Router do
  # alias SocialNetworkAppWeb.AccountController
  # alias SocialNetworkAppWeb.ProductController
  use SocialNetworkAppWeb, :router

  use Plug.ErrorHandler

  def handle_errors(conn, %{reason: %Phoenix.Router.NoRouteError{message: message}}) do
    conn |> json(%{errors: message}) |> halt()
  end

  def handle_errors(conn, %{reason: %{message: message}}) do
    conn |> json(%{errors: message}) |> halt()
  end

  def handle_errors(conn, %{reason: %Maru.Params.ParseError{reason: message}}) do
    conn |> json(%{errors: message}) |> halt()
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  pipeline :auth do
    plug SocialNetworkAppWeb.Guardian.Pipeline
    plug SocialNetworkAppWeb.Guardian.SetConnUser
  end

  scope "/api/users", SocialNetworkAppWeb do
    pipe_through :api

    post "/register", AccountController, :create
    post "/login", AccountController, :login
    get "/:id", AccountController, :show
  end

  scope "/api/users", SocialNetworkAppWeb do
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

  scope "/api/pictures", SocialNetworkAppWeb do
    pipe_through [:api, :auth]

    post "/:id/raiting", RaitingController, :create
  end

  scope "/api/pictures", SocialNetworkAppWeb do
    pipe_through [:api]

    get "/", PictureController, :index
    get "/:id", PictureController, :show
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
