ExUnit.start()
# this is used to clean up the database for tests

Ecto.Adapters.SQL.query!(Tpe.Repo, "DELETE FROM coupons WHERE promo_id < 100")
