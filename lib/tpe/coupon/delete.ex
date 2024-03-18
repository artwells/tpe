defmodule Tpe.Coupon.Delete do
  @moduledoc """
  This module provides functions to delete coupons from the database.
  """

  import Ecto.Query, only: [from: 2]

  @doc """
  Deletes all coupons with a given promo ID.

  ## Examples

      iex> Tpe.Coupon.Delete.delete_by_promo_id(123)
      :ok

  """
  def delete_by_promo_id(promo_id) do
    from(c in Tpe.Coupon, where: c.promo_id == ^promo_id)
    |> Tpe.Repo.delete_all()
  end

  @doc """
  Deletes all coupons inserted before a given date.

  ## Examples

      iex> Tpe.Coupon.Delete.delete_by_inserted_at_before(~D[2022-01-01])
      :ok

  """
  def delete_by_inserted_at_before(date) do
    from(c in Tpe.Coupon, where: c.inserted_at < ^date)
    |> Tpe.Repo.delete_all()
  end
end
