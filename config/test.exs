import Config

config :tpe, Tpe.Repo,
  database: "tpe",
  username: "postgres",
  password: "postgres",
  hostname: "db",
  pool: Ecto.Adapters.SQL.Sandbox,
  show_sensitive_data_on_connection_error: true,
  pool_size: 30

config :logger, level: :info
