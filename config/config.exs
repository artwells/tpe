import Config



config :tpe, Tpe.Repo,
  migration_timestamps: [
    type: :timestamptz,
    autogenerate: DateTime.utc_now()
  ]

config :tpe,
  ecto_repos: [Tpe.Repo],
  chunk_size: 1000,
  # less ambiguous characters, could be any set, must not include "-"
  code_characters: ~c"ABCDEFGHJKLMNPQRTUVWXY346789",
  # remove dashes from codes on validation. Don not set to false if you use get_coupon_codes_by_promo_id_with_dashes()
  remove_dashes: true,
  # length of the coupon code
  code_length: 24,
  insert_all_timeout: 30_000


import_config "#{config_env()}.exs"
