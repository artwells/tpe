defmodule Tpe.Coupon.Update do
  import Ecto.Query, only: [from: 2]

  @doc """
  Increments the count of a coupon.

  ## Examples
  iex> Tpe.TestTools.cleanup()
  iex> {:ok, coupon} = Tpe.Coupon.Create.create_coupon(%{code: "ABC12387", active: true, count: 5, max_use: 6, promo_id: 1})
  iex> {:ok, _coupon} = Tpe.Coupon.Update.increment_use(coupon)
  iex> {:ok, updated_coupon} = Tpe.Coupon.Read.get_coupon(coupon.id)
  iex> updated_coupon.count
  6
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

  ## Examples
  iex> Tpe.TestTools.cleanup()
  iex> {:ok, coupon} = Tpe.Coupon.Create.create_coupon(%{code: "ABC12387", active: true, count: 5, max_use: 6, promo_id: 1})
  iex> {:ok, _coupon} = Tpe.Coupon.Update.update_coupon(coupon, %{active: false, count: 5, promo_id: 2})
  iex> {:ok, updated_coupon} = Tpe.Coupon.Read.get_coupon(coupon.id)
  iex> updated_coupon.promo_id
  2
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

  ## Examples
  iex> Tpe.TestTools.cleanup()
  iex> {:ok, coupon1} = Tpe.Coupon.Create.create_coupon(%{code: "ABC123", active: false, count: 10, promo_id: 1})
  iex> {:ok, coupon2} = Tpe.Coupon.Create.create_coupon(%{code: "DEF456", active: false, count: 5, promo_id: 1})
  iex> Coupon.Update.set_active_by_promo_id(1, true)
  {2, nil}
  iex> updated_coupon1 = Tpe.Repo.get(Tpe.Coupon, coupon1.id)
  iex> updated_coupon2 = Tpe.Repo.get(Tpe.Coupon, coupon2.id)
  iex> updated_coupon1.active
  true
  iex> updated_coupon2.active
  true

  ## Params

  - `promo_id` (`any`): The promo ID.
  - `active` (`boolean`): The active status to set.

  ## Returns

  The number of coupons updated.
  """
  def set_active_by_promo_id(promo_id, active) do
    now = DateTime.utc_now()

    from(c in Tpe.Coupon,
      where: c.promo_id == ^promo_id,
      update: [set: [active: ^active, updated_at: ^now]]
    )
    |> Tpe.Repo.update_all([])
  end
end
