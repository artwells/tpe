import Config

config :tpe, Tpe.Repo,
  database: "tpe",
  username: "postgres",
  password: "postgres",
  hostname: "db",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 30

config :logger, level: :info
