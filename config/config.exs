# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :wms_task,
  ecto_repos: [WmsTask.Repo]

# Configures the endpoint
config :wms_task, WmsTaskWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "4wrtVzb/rbHVStZfWRSioi42ooWJdqoz99DDZpsVPeLkv5cPLTu6g+toJr8SBSOj",
  render_errors: [view: WmsTaskWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: WmsTask.PubSub,
  live_view: [signing_salt: "VknTDu1/"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :wms_task, WmsTaskWeb.Scheduler,
  jobs: [
    # Every 1 minute
    {"*/1 * * * *", {WmsTask.Orders, :sync_orders, []}}
  ]

config :wms_task, WmsTask.Pulpo,
  adapter: WmsTask.Pulpo.Api,
  base_url: "https://show.pulpo.co/api/v1",
  user: "felipe_user1"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
