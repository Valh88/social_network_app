# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :social_network_app,
  ecto_repos: [SocialNetworkApp.Repo]

# Configures the endpoint
config :social_network_app, SocialNetworkAppWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [json: SocialNetworkAppWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: SocialNetworkApp.PubSub,
  live_view: [signing_salt: "031OFCn+"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :social_network_app, SocialNetworkApp.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.

config :social_network_app, SocialNetworkAppWeb.Guardian.GuardianAuth,
  issuer: "social_network_app",
  secret_key: "KW1gjrnxpNQl584klnLqX5Mh4KF9DIyEhnCZmUdhTWqRmtqKbcPSscdCOJIL1Yni"

config :guardian, Guardian.DB,
  repo: SocialNetworkApp.Repo,
  schema_name: "guardian_token",
  sweep_interval: 60

import_config "#{config_env()}.exs"
