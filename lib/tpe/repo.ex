defmodule Tpe.Repo do
  use Ecto.Repo,
    otp_app: :tpe,
    adapter: Ecto.Adapters.Postgres
end
