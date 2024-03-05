defmodule Low.CouponTest do
  use ExUnit.Case
  use Ecto.Repo, otp_app: :my_app, adapter: Ecto.Adapters.Postgres
  alias Low.Coupon

  setup do
    :ok
  end


  test "changeset/2 casts and validates the coupon changeset" do
    changeset = Coupon.changeset(%Coupon{}, %{code: "ABC123", active: true, count: 10, promo_id: 1})

    assert changeset.valid?
    assert %{code: "ABC123", active: true, count: 10, promo_id: 1} == changeset.changes
  end

  test "create_coupon/1 creates a new coupon" do
    attrs = %{code: "DEF456", active: true, count: 5, promo_id: 2}
    {:ok, coupon} = Coupon.create_coupon(attrs)

    assert %Low.Coupon{} = coupon
    assert "DEF456" == coupon.code
    assert true == coupon.active
    assert 5 == coupon.count
    assert 2 == coupon.promo_id
  end

  test "increment_count/1 increments the count of a coupon" do
    coupon = %{code: "ABC1238", active: true, count: 10, promo_id: 1}
    {:ok, coupon} = Coupon.create_coupon(coupon)
    {:ok, updated_coupon} = Coupon.increment_count(coupon)

    assert %Low.Coupon{} = updated_coupon
    assert 11 == updated_coupon.count
  end

  test "change_coupon/2 changes the attributes of a coupon" do
    coupon = %{code: "ABC123", active: true, count: 10, promo_id: 1}
    {:ok, coupon} = Coupon.create_coupon(coupon)
    attrs = %{code: "DEF456", active: false, count: 5, promo_id: 2}
    {:ok, updated_coupon} = Coupon.change_coupon(coupon, attrs)

    assert %Low.Coupon{} = updated_coupon
    assert "DEF456" == updated_coupon.code
    assert false == updated_coupon.active
    assert 5 == updated_coupon.count
    assert 2 == updated_coupon.promo_id
  end

  test "get_coupon/1 retrieves a coupon by id" do
    {:ok, coupon} = Coupon.create_coupon(%{code: "ABC1235", active: true, count: 10, promo_id: 1})
    retrieved_coupon = Coupon.get_coupon(coupon.id)

    assert %Low.Coupon{} = retrieved_coupon
    assert "ABC1235" == retrieved_coupon.code
    assert true == retrieved_coupon.active
    assert 10 == retrieved_coupon.count
    assert 1 == retrieved_coupon.promo_id
  end

  test "get_coupon_by_code/1 retrieves a coupon by code" do
    {:ok, retrieved_coupon} = Coupon.create_coupon(%{code: "ABC1236", active: true, count: 10, promo_id: 1})
    # retrieved_coupon = Coupon.get_coupon_by_code("ABC123")

    assert %Low.Coupon{} = retrieved_coupon
    assert "ABC1236" == retrieved_coupon.code
    assert true == retrieved_coupon.active
    assert 10 == retrieved_coupon.count
    assert 1 == retrieved_coupon.promo_id
  end
end
