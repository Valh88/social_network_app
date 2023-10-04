defmodule SocialNetworkApp.Repo do
  use Ecto.Repo,
    otp_app: :social_network_app,
    adapter: Ecto.Adapters.Postgres
end
