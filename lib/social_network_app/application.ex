defmodule SocialNetworkApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      SocialNetworkAppWeb.Telemetry,
      # Start the Ecto repository
      SocialNetworkApp.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: SocialNetworkApp.PubSub},
      # Start Finch
      {Finch, name: SocialNetworkApp.Finch},
      # Start the Endpoint (http/https)
      SocialNetworkAppWeb.Endpoint,
      # Start a worker by calling: SocialNetworkApp.Worker.start_link(arg)
      # {SocialNetworkApp.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SocialNetworkApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SocialNetworkAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
