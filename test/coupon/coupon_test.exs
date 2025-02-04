defmodule Tpe.CouponTest do
  use ExUnit.Case, async: false
  use Ecto.Repo, otp_app: :my_app, adapter: Ecto.Adapters.Postgres
  alias Tpe.Coupon
  doctest Tpe.Coupon, import: true

  test "changeset/2 casts and validates the coupon changeset" do
    changeset =
      Coupon.changeset(%Coupon{}, %{code: "ABC123", active: true, count: 10, promo_id: 1})

    assert changeset.valid?
    assert %{code: "ABC123", active: true, count: 10, promo_id: 1} == changeset.changes
  end
end
