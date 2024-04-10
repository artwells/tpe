defmodule Tpe.Coupon.Delete do
  @moduledoc """
  This module provides functions to delete coupons from the database.
  """

  import Ecto.Query, only: [from: 2]

  @doc """
  Deletes all coupons with a given promo ID.

  ## Examples
  iex> {:ok, coupon} = Tpe.Coupon.Create.create_coupon(%{code: "ABC12387", active: true, count: 5, max_use: 6, promo_id: 1})
  iex> coup = Map.from_struct(coupon)
  iex> Tpe.Coupon.Delete.delete_by_promo_id(coup.promo_id)
  {1, nil}

  ## Params
  - promo_id (integer): The promo ID.
  ## Returns
  - {:ok, nil}: If the coupons are deleted.
  """
  def delete_by_promo_id(promo_id) do
    from(c in Tpe.Coupon, where: c.promo_id == ^promo_id)
    |> Tpe.Repo.delete_all()
  end

  @doc """
  Deletes all coupons inserted before a given date.

  ## Examples
  iex> Tpe.TestTools.cleanup()
  iex> {:ok, _} = Tpe.Coupon.Create.create_coupon(%{code: "ABC12387", active: true, count: 5, max_use: 6, promo_id: 1})
  iex> Tpe.Coupon.Delete.delete_by_inserted_at_before(~U[2048-11-15 10:00:00Z])
  {1, nil}

  ## Params
  - `date` (`DateTime`): The date.

  ## Returns
  - `{:ok, nil}`: If the coupons are deleted.
  """

  def delete_by_inserted_at_before(date) do
    from(c in Tpe.Coupon, where: c.inserted_at < ^date)
    |> Tpe.Repo.delete_all()
  end
end
