defmodule Tpe.Coupon.Update do
  import Ecto.Query, only: [from: 2]

  @doc """
  Increments the count of a coupon.

  ## Params

  - `coupon` (`Tpe.Coupon`): The coupon struct.

  ## Returns

  The updated coupon.
  """
  def increment_use(coupon) do
    coupon
    |> Ecto.Changeset.change(count: coupon.count + 1)
    |> Tpe.Repo.update()
  end

  @doc """
  Changes a coupon.

  ## Params

  - `coupon` (`Tpe.Coupon`): The coupon struct.
  - `attrs` (`map`): The attributes to update the coupon with.

  ## Returns

  The updated coupon.
  """
  def update_coupon(coupon, attrs \\ %{}) do
    attrs = Map.put(attrs, :updated_at, DateTime.utc_now())
    coupon
    |> Tpe.Coupon.changeset(attrs)
    |> Tpe.Repo.update()
  end

  @doc """
  Sets the active status of coupons by promo ID.

  ## Params

  - `promo_id` (`any`): The promo ID.
  - `active` (`boolean`): The active status to set.

  ## Returns

  The number of coupons updated.
  """
  def set_active_by_promo_id(promo_id, active) do
    now = DateTime.utc_now()
    from(c in Tpe.Coupon, where: c.promo_id == ^promo_id,
    update: [set: [active: ^active, updated_at: ^now]])
    |> Tpe.Repo.update_all([])
  end

end
