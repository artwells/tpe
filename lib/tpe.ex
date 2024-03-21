defmodule Tpe do
  @moduledoc """
  Documentation for `Tpe`.
  """



  @doc """
    Validates a coupon code.

    ## Examples
        import Tpe.Coupon.Create

        iex> Tpe.Coupon.Create.create_coupon(%{code: "ABC12387", active: true, count: 5, max_use: 6, promo_id: 1})
        iex> {:error, _} = Tpe.validate_coupon("ABC12388")
        iex> {:ok, _} = Tpe.validate_coupon("ABC12387")

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
