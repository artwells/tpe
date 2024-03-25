defmodule Tpe do
  @moduledoc """
  Documentation for `Tpe`.
  """

  @doc """
  Validates a coupon code.
  ## Parameters
    - `coupon_code` (`string`): The coupon code to validate.
    ##Returns
    - `{:ok, coupon}`: A tuple with the coupon struct if the coupon is valid.
    - `{:error, error}`: A tuple with the error message if the coupon is invalid.

  ## Examples
    iex> Tpe.TestTools.cleanup()
    iex> {:ok, success_count} = Tpe.Coupon.Create.create_coupon("123456", 13)
    iex> Tpe.validate_coupon("123456")
    {:ok, %Tpe.Coupon{code: "123456", promo_id: 13}}
    iex> Tpe.validate_coupon("1234567")
    {:error, "Coupon not found"}
  """
  def validate_coupon(coupon_code) do
    case Tpe.Coupon.Read.get_valid_coupon(coupon_code) do
      {:ok, coupon} ->
        {:ok, coupon}

      {:error, error} ->
        {:error, error}
    end
  end
end
