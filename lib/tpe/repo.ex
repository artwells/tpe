defmodule Tpe.Repo do
  use Ecto.Repo,
    otp_app: :low,
    adapter: Ecto.Adapters.Postgres
end
