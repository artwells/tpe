defmodule Tpe.Test.Coupon.Delete do
  use ExUnit.Case, async: true
  use Ecto.Repo, otp_app: :my_app, adapter: Ecto.Adapters.Postgres
  alias Tpe.TestTools
  alias Tpe.Coupon
  doctest Tpe.Coupon.Delete, import: true


  setup do
    TestTools.sandbox_connection()
    :ok
  end

  setup_all do
    TestTools.cleanup()
    :ok
  end

  test "delete_by_promo_id/1 deletes all coupons with a given promo_id" do
    promo_id = 12
    {:ok, _coupon1} = Coupon.Create.create_coupon(%{code: "ABC123", active: true, count: 10, promo_id: promo_id})
    {:ok, _coupon2} = Coupon.Create.create_coupon(%{code: "DEF456", active: true, count: 5, promo_id: promo_id})
    {:ok, _coupon3} = Coupon.Create.create_coupon(%{code: "GHI789", active: true, count: 8, promo_id: promo_id})

    deleted_count = Coupon.Delete.delete_by_promo_id(promo_id)

    assert deleted_count == {3, nil}
    assert [] == Tpe.Repo.all(Tpe.Coupon)
  end

  test "delete_by_inserted_at_before/1 deletes all coupons inserted before a given date" do
    {:ok, coupon1} = Coupon.Create.create_coupon(%{code: "TIMEABC123", active: true, count: 10, promo_id: 1})
    {:ok, coupon2} = Coupon.Create.create_coupon(%{code: "TIMEDEF456", active: true, count: 5, promo_id: 2})
    {:ok, coupon3} = Coupon.Create.create_coupon(%{code: "TIMEGHI789", active: true, count: 8, promo_id: 3})
    query = """
    UPDATE coupons SET
    inserted_at = $1
    WHERE id = $2
  """
    Ecto.Adapters.SQL.query!(Tpe.Repo, query, [DateTime.add(DateTime.utc_now(),-10000), coupon1.id])
    Ecto.Adapters.SQL.query!(Tpe.Repo, query, [DateTime.add(DateTime.utc_now(),-10000), coupon2.id])
    Ecto.Adapters.SQL.query!(Tpe.Repo, query, [DateTime.add(DateTime.utc_now(),10000), coupon3.id])
    date = DateTime.utc_now()
    deleted_count = Coupon.Delete.delete_by_inserted_at_before(date)
    assert deleted_count == {2, nil}

    #get all remaining coupons
    count = Tpe.Repo.all(Tpe.Coupon)
    |> Enum.count()

    assert count == 1
  end

end
