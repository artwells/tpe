defmodule Tpe.CouponTest.Update do
  use ExUnit.Case, async: true
  use Ecto.Repo, otp_app: :my_app, adapter: Ecto.Adapters.Postgres
  alias Tpe.Coupon
  doctest Tpe.Coupon.Update, import: true

  test "increment_use/1 increments the count of a coupon" do
    coupon = %{code: "ABC1238", active: true, count: 10, promo_id: 1}
    {:ok, coupon} = Coupon.Create.create_coupon(coupon)
    {:ok, updated_coupon} = Coupon.Update.increment_use(coupon)

    assert %Tpe.Coupon{} = updated_coupon
    assert 11 == updated_coupon.count
  end

  test "update_coupon/2 changes the attributes of a coupon" do
    Tpe.TestTools.cleanup()
    coupon = %{code: "ABC1239", active: true, count: 10, promo_id: 1}
    {:ok, coupon} = Coupon.Create.create_coupon(coupon)
    attrs = %{code: "DEF456", active: false, count: 5, promo_id: 2}
    {:ok, updated_coupon} = Coupon.Update.update_coupon(coupon, attrs)

    assert %Tpe.Coupon{} = updated_coupon
    assert "DEF456" == updated_coupon.code
    assert false == updated_coupon.active
    assert 5 == updated_coupon.count
    assert 2 == updated_coupon.promo_id
  end

  # test that checks that updated_at is updated when a coupon is changed and inserted_at is unchanged
  test "updated_at is updated when a coupon is changed" do
    {:ok, coupon} =
      Coupon.Create.create_coupon(%{code: "ABC12390", active: true, count: 10, promo_id: 1})

    {:ok, retrieved_coupon} = Coupon.Read.get_coupon(coupon.id)
    updated_at = retrieved_coupon.updated_at
    inserted_at = retrieved_coupon.inserted_at
    Process.sleep(1000)

    {:ok, updated_coupon} =
      Coupon.Update.update_coupon(retrieved_coupon, %{count: 7, promo_id: 2})

    assert :lt == DateTime.compare(updated_at, updated_coupon.updated_at)
    assert :eq == DateTime.compare(inserted_at, updated_coupon.inserted_at)
  end

  test "set_active_by_promo_id/2 sets the active status of coupons by promo_id" do
    Tpe.TestTools.cleanup()
    promo_id = 1
    active = true

    {:ok, coupon1} =
      Coupon.Create.create_coupon(%{code: "ABC123", active: false, count: 10, promo_id: promo_id})

    {:ok, coupon2} =
      Coupon.Create.create_coupon(%{code: "DEF456", active: false, count: 5, promo_id: promo_id})

    {:ok, coupon3} =
      Coupon.Create.create_coupon(%{code: "GHI789", active: false, count: 8, promo_id: promo_id})

    {:ok, coupon4} =
      Coupon.Create.create_coupon(%{code: "GHI000", active: false, count: 8, promo_id: 8})

    Process.sleep(2000)
    assert {3, nil} == Coupon.Update.set_active_by_promo_id(promo_id, active)

    updated_coupon1 = Tpe.Repo.get(Tpe.Coupon, coupon1.id)
    updated_coupon2 = Tpe.Repo.get(Tpe.Coupon, coupon2.id)
    updated_coupon3 = Tpe.Repo.get(Tpe.Coupon, coupon3.id)
    updated_coupon4 = Tpe.Repo.get(Tpe.Coupon, coupon4.id)

    assert true == updated_coupon1.active
    assert true == updated_coupon2.active
    assert true == updated_coupon3.active
    refute true == updated_coupon4.active

    assert updated_coupon1.updated_at > coupon1.updated_at
    assert updated_coupon2.updated_at > coupon2.updated_at
    assert updated_coupon3.updated_at > coupon3.updated_at
    assert updated_coupon4.updated_at == coupon4.updated_at
  end
end
