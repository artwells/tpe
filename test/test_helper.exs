ExUnit.start()

Ecto.Adapters.SQL.query!(Tpe.Repo, "DELETE FROM coupons WHERE promo_id IN (1,2,3)" )
