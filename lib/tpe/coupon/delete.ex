defmodule Tpe.Coupon.Delete do
  import Ecto.Query, only: [from: 2]
  # Deletes all coupons with a given promo_id.
  #
  # ## Examples
  #
  #     iex> Tpe.Coupon.delete_by_promo_id(123)
  #
  # @param promo_id [integer] the promo_id to match
  # @return [integer] the number of deleted coupons
  def delete_by_promo_id(promo_id) do
    from(c in Tpe.Coupon, where: c.promo_id == ^promo_id)
    |> Tpe.Repo.delete_all()
  end

    def delete_by_inserted_at_before(date) do
      from(c in Tpe.Coupon, where: c.inserted_at < ^date)
      |> Tpe.Repo.delete_all()
    end

end
