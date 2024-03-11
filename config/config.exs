import Config

config :tpe, Tpe.Repo,
  database: "tpe",
  username: "postgres",
  password: "postgres",
  hostname: "db"

config :tpe, ecto_repos: [Tpe.Repo]

config :tpe, Tpe.Repo, migration_timestamps: [
  type: :timestamptz,
  autogenerate: DateTime.utc_now()
]

config :tpe,
  chunk_size: 10000,
  code_characters: 'ABCDEFGHJKLMNPQRTUVWXY346789', # less ambiguous characters, could be any set, must not include "-"
  code_length: 24,
  insert_all_timeout: 30_000
