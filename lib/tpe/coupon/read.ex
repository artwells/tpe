defmodule Tpe.Coupon.Read do
  use Ecto.Schema
  use Ecto.Repo, otp_app: :my_app, adapter: Ecto.Adapters.Postgres
  import Ecto.Query, only: [from: 2]


  @moduledoc """
  This module provides functions for reading coupons.
  """

  # Rest of the code...


  @doc """
  Retrieves a coupon by ID.

  ## Params

  - `id` (`integer`): The ID of the coupon.

  ## Returns

  - `{:ok, coupon}`: If the coupon is found.
  - `{:error, :coupon_not_found}`: If the coupon is not found.
  """
  def get_coupon(id) do
    coupon = Tpe.Repo.get(Tpe.Coupon, id)
    cond do
      coupon == nil ->
        {:error, :coupon_not_found}
      true ->
        {:ok, coupon}
    end
  end

  @doc """
  Retrieves a coupon by code.

  ## Params

  - `code` (`string`): The code of the coupon.

  ## Returns

  - `{:ok, coupon}`: If the coupon is found.
  - `{:error, :coupon_not_found}`: If the coupon is not found.
  """
  def get_coupon_by_code(code) do
    code =
    cond do
      Application.fetch_env!(:tpe, :remove_dashes) ->
        String.replace(code, "-", "")
      true -> code
    end

    coupon = Tpe.Repo.get_by(Tpe.Coupon, code: code)
    cond do
      coupon == nil ->
        {:error, :coupon_not_found}
      true ->
        {:ok, coupon}
    end
  end

  @doc """
  Retrieves a valid coupon by code.

  A coupon is considered valid if it is active and the count is not greater than the max_use.

  ## Params

  - `code` (`string`): The code of the coupon.

  ## Returns

  - `{:ok, coupon}`: If the coupon is valid.
  - `{:error, :coupon_not_active}`: If the coupon is not active.
  - `{:error, :coupon_count_greater_than_max_use}`: If the coupon count is greater than the max_use.
  - `{:error, :coupon_not_found}`: If the coupon is not found.
  """
  def get_valid_coupon(code) do
    case get_coupon_by_code(code) do
      {:ok, coupon} ->
        cond do
          coupon.active != :true ->
            {:error, :coupon_not_active}
          coupon.max_use != 0 && coupon.count >= coupon.max_use ->
            {:error, :coupon_count_greater_than_max_use}
          true ->
            {:ok, coupon}
        end
      {:error, error} ->
        {:error, error}
    end
  end




  # get all coupons by promo_id
  @doc """
  Retrieves all coupons associated with a given promo_id.

  ## Examples

      iex> Tpe.Coupon.Read.get_coupons_by_promo_id(123)
      [%Tpe.Coupon{...}, ...]

  """
  def dump_coupons_by_promo_id(promo_id) do
    Tpe.Repo.all(from(c in Tpe.Coupon, where: c.promo_id == ^promo_id))
  end

  # add dashes to codes returned by dump_coupon_codes_by_promo_id
  # Adds dashes to coupon codes at specified intervals.
  #
  # This function takes a list of coupon codes and adds dashes at specified intervals.
  # The `codes` parameter is a list of coupon codes to be processed.
  # The `interv` parameter is the interval at which dashes should be added.
  #
  # Returns a new list of coupon codes with dashes added at the specified intervals.
  defp add_dashes_to_codes(codes, interv) do
    Enum.map(codes, fn code -> String.replace_trailing(String.replace(code, ~r/(.{#{interv}})/, "\\1-"),"-","") end)
  end

  def dump_coupon_codes_by_promo_id_with_dashes(promo_id, interv \\ nil) do
    codes = Tpe.Repo.all(from(c in Tpe.Coupon, where: c.promo_id == ^promo_id, select: c.code))
    cond do
      is_nil(interv) ->
        codes
      true ->
        add_dashes_to_codes(codes, interv)
    end
  end
end
