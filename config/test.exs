use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
database_url =
  System.get_env("DATABASE_URL", "postgres://postgres:postgres@localhost:5432/wms_task")

config :wms_task, WmsTask.Repo,
  url: database_url <> "_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :wms_task, WmsTaskWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :wms_task, WmsTask.Pulpo, adapter: WmsTask.PulpoMock
