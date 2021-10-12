import Config

database_url = System.fetch_env!("DATABASE_URL")

config :wms_task, WmsTask.Repo,
  # ssl: true,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

secret_key_base =
  System.fetch_env!("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :wms_task, WmsTaskWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base

config :wms_task, WmsTask.Pulpo,
  adapter: WmsTask.Pulpo.Api,
  base_url: System.fetch_env!("PULPO_URL"),
  user: System.fetch_env!("PULPO_USER")
