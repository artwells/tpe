ExUnit.start()

Ecto.Adapters.SQL.query!(Low.Repo, "DELETE FROM coupons WHERE promo_id IN (1,2)" )
