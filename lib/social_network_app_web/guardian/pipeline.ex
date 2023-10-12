defmodule SocialNetworkAppWeb.Guardian.Pipeline do
  use Guardian.Plug.Pipeline, otp_app: :social_network_app,
  module: SocialNetworkAppWeb.Guardian.GuardianAuth,
  error_handler: SocialNetworkAppWeb.Guardian.GuardianErrorHandler

  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
