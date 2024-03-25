defmodule Tpe.Coupon do
  @moduledoc """
  This module defines the `Tpe.Coupon` schema and changeset
  """

  use Ecto.Schema
  import Ecto.Changeset

  @doc """
  The `coupons` schema represents a coupon record in the database.

  ## Fields

  - `code` (`string`): The coupon code.
  - `active` (`boolean`): Indicates whether the coupon is active or not.
  - `count` (`integer`): The current count of the coupon.
  - `max_use` (`integer`): The maximum count allowed for the coupon.
  - `promo_id` (`integer`): The ID of the associated promo.
  - `inserted_at` (`utc_datetime`): The timestamp when the coupon was inserted.
  - `updated_at` (`utc_datetime`): The timestamp when the coupon was last updated.
  """
  schema "coupons" do
    field :code, :string
    field :active, :boolean
    field :count, :integer
    field :max_use, :integer
    field :promo_id, :integer
    field :inserted_at, :utc_datetime_usec
    field :updated_at, :utc_datetime_usec
  end

  @doc """
  Creates a changeset for a coupon.

  ## Examples
    iex>  coupon = %Tpe.Coupon{}
    iex>  Tpe.Coupon.changeset(coupon, %{code: "ABC123", active: true, count: 10, promo_id: 1})
    #Ecto.Changeset<action: nil, changes: %{active: true, code: "ABC123", count: 10, promo_id: 1}, errors: [], data: #Tpe.Coupon<>, valid?: true>

  ## Params

  - `coupon` (`Tpe.Coupon`): The coupon struct.
  - `params` (`map`): The parameters to update the coupon with.

  ## Returns

  A changeset for the coupon.
  """
  def changeset(coupon, params \\ %{}) do
    coupon
    |> cast(params, [:code, :active, :count, :max_use, :promo_id, :updated_at])
    |> validate_required([:code, :promo_id])
  end

end
