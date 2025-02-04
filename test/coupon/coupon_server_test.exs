defmodule Tpe.Coupon.CouponServerTest do
  use ExUnit.Case
  alias Tpe.Coupon.CouponServer

  # Setup the CouponServer with a coupon
  setup do
    {:ok, _pid} = CouponServer.start_link(%{"coupon1" => %{id: "coupon1", discount: 10}})
    :ok
  end

  test "get_coupon/1 returns the correct coupon" do
    assert CouponServer.get_coupon("coupon1") == %{id: "coupon1", discount: 10}
  end

  test "get_coupon/1 returns nil for non-existent coupon" do
    assert CouponServer.get_coupon("XXNOTACOUPONXX") == nil
  end
end
