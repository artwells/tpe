defmodule Tpe.TestTools do
  def cleanup do
    Ecto.Adapters.SQL.query!(Tpe.Repo, "DELETE FROM coupons WHERE promo_id < 100")
    Ecto.Adapters.SQL.query!(Tpe.Repo, "DELETE FROM rule_parts WHERE rule_id < 100")
  end
  def sandbox_connection() do
    Ecto.Adapters.SQL.Sandbox.checkout(Tpe.Repo)
  end
end
