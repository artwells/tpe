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
  max_chunk: 10000,
  code_characters: 'ABCDEFGHJKLMNPQRTUVWXY346789', # less ambiguous characters, could be any set, must not include "-"
  code_length: 24,
  insert_all_timeout: 30_000
