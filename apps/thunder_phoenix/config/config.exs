# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :thunder_phoenix,
  namespace: ThunderPhoenix,
  ecto_repos: [ThunderPhoenix.Repo]

# Configures the endpoint
config :thunder_phoenix, ThunderPhoenixWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "QUgQb41CA+Gbuz7l5TAKp3W0/Ghi/UdQVTkpNwDoX0x4npTceKMLU8mB3KLMeKYH",
  render_errors: [view: ThunderPhoenixWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ThunderPhoenix.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"