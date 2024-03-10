import Config

config :low, Low.Repo,
  database: "low",
  username: "postgres",
  password: "postgres",
  hostname: "db"

config :low, ecto_repos: [Low.Repo]

config :low, Low.Repo, migration_timestamps: [
  type: :timestamptz,
  autogenerate: DateTime.utc_now()
]

config :low,
  max_chunk: 10000
