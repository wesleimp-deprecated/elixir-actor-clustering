# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :cluster_user, ClusterUserWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "JGKI5iE4q4fgxcoKWdyo3T/oASk0ZcSQY6O/g2XX4n3UmmWRB3BMs+ncUQiGivA6",
  render_errors: [view: ClusterUserWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ClusterUser.PubSub,
  live_view: [signing_salt: "wHGfRId0"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$date $time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Config libcluster
config :libcluster,
  topologies: [
    local: [
      strategy: Cluster.Strategy.Gossip
    ]
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
