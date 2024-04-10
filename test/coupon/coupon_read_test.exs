defmodule Tpe.CouponTest.Read do
  use ExUnit.Case, async: true
  use Ecto.Repo, otp_app: :my_app, adapter: Ecto.Adapters.Postgres
  alias Tpe.Coupon
  doctest Tpe.Coupon.Read, import: true


  setup_all do
    Tpe.TestTools.cleanup()
    :ok
  end

  test "get_coupon/1 retrieves a coupon by id" do
    {:ok, coupon} =
      Coupon.Create.create_coupon(%{code: "ABC1235", active: true, count: 10, promo_id: 1})

    {:ok, retrieved_coupon} = Coupon.Read.get_coupon(coupon.id)

    assert %Tpe.Coupon{} = retrieved_coupon
    assert "ABC1235" == retrieved_coupon.code
    assert true == retrieved_coupon.active
    assert 10 == retrieved_coupon.count
    assert 1 == retrieved_coupon.promo_id
  end

  test "get_coupon_by_code/1 retrieves a coupon by code" do
    Coupon.Create.create_coupon(%{code: "ABC1236", active: true, count: 10, promo_id: 1})

    {:error, error} = Coupon.Read.get_coupon_by_code("ABC1236NOTACOUPON")
    assert :coupon_not_found == error
    {:ok, retrieved_coupon} = Coupon.Read.get_coupon_by_code("ABC1236")
    assert %Tpe.Coupon{} = retrieved_coupon
    assert "ABC1236" == retrieved_coupon.code
    assert true == retrieved_coupon.active
    assert 10 == retrieved_coupon.count
    assert 1 == retrieved_coupon.promo_id

    # test that coupon is still retrieved if dashes are included
    {:ok, retrieved_coupon} = Coupon.Read.get_coupon_by_code("ABC-1236")
    assert %Tpe.Coupon{} = retrieved_coupon
    assert "ABC1236" == retrieved_coupon.code
  end

  test "get_valid_coupon/1 retrieves active coupon by code and count" do
    {:ok, _coupon} =
      Coupon.Create.create_coupon(%{
        code: "ABC12307",
        active: true,
        count: 5,
        max_use: 6,
        promo_id: 1
      })

    {:error, error} = Coupon.Read.get_valid_coupon("ABC1236NOTACOUPON")
    assert :coupon_not_found == error

    {:ok, retrieved_coupon} = Coupon.Read.get_valid_coupon("ABC12307")
    assert %Tpe.Coupon{} = retrieved_coupon
    assert "ABC12307" == retrieved_coupon.code
    assert true == retrieved_coupon.active
    assert 5 == retrieved_coupon.count
    assert 1 == retrieved_coupon.promo_id

    {:ok, _updated_coupon} = Coupon.Update.update_coupon(retrieved_coupon, %{active: false})
    {:error, error} = Coupon.Read.get_valid_coupon("ABC12307")
    assert :coupon_not_active == error
    {:ok, retrieved_coupon} = Coupon.Read.get_coupon_by_code("ABC12307")
    {:ok, _updated_coupon} = Coupon.Update.update_coupon(retrieved_coupon, %{active: true})
    # increase count to 11 and test for error
    {:ok, _updated_coupon} = Coupon.Update.increment_use(retrieved_coupon)
    {:error, error} = Coupon.Read.get_valid_coupon("ABC12307")
    assert :coupon_count_greater_than_max_use == error
    # check that if the max_use is zero, no coupon_counter_greater_than_max_use error is returned
    {:ok, _updated_coupon} = Coupon.Update.update_coupon(retrieved_coupon, %{max_use: 0})
    {:ok, infinite_coupon} = Coupon.Read.get_valid_coupon("ABC12307")
    assert "ABC12307" = infinite_coupon.code
  end

  test "dump_coupons_by_promo_id/1 retrieves all coupons associated with a given promo_id" do
    {:ok, coupon1} =
      Coupon.Create.create_coupon(%{code: "BYPROMOABC123", active: true, count: 10, promo_id: 4})

    {:ok, coupon2} =
      Coupon.Create.create_coupon(%{code: "BYPROMODEF456", active: true, count: 5, promo_id: 4})

    {:ok, coupon3} =
      Coupon.Create.create_coupon(%{code: "BYPROMOGHI789", active: true, count: 8, promo_id: 5})

    coupons = Coupon.Read.dump_coupons_by_promo_id(4)
    assert Enum.any?(coupons, fn coupon -> coupon.id == coupon1.id end)
    assert Enum.any?(coupons, fn coupon -> coupon.id == coupon2.id end)
    refute Enum.any?(coupons, fn coupon -> coupon.id == coupon3.id end)
  end

  test "dump_coupon_codes_by_promo_id_with_dashes/2 retrieves coupon codes by promo_id with dashes" do
    promo_id = 6
    interv = 3

    coupons = [
      %{code: "ABC1234", active: true, count: 10, promo_id: 6},
      %{code: "DEF5678", active: true, count: 5, promo_id: 6},
      %{code: "GHI9101", active: true, count: 5, promo_id: 6},
      %{code: "JKL1213", active: true, count: 5, promo_id: 6}
    ]

    {:ok, _} = Tpe.Coupon.Create.insert_coupons(coupons)

    expected_codes = [
      "ABC-123-4",
      "DEF-567-8",
      "GHI-910-1",
      "JKL-121-3"
    ]

    actual_codes = Tpe.Coupon.Read.dump_coupon_codes_by_promo_id_with_dashes(promo_id, interv)

    assert expected_codes == actual_codes

    expected_undashed_codes = [
      "ABC1234",
      "DEF5678",
      "GHI9101",
      "JKL1213"
    ]

    actual_codes = Tpe.Coupon.Read.dump_coupon_codes_by_promo_id_with_dashes(promo_id, nil)

    assert expected_undashed_codes == actual_codes
  end
end
