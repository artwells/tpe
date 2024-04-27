defmodule Tpe.Coupon.Read do
  use Ecto.Schema
  use Ecto.Repo, otp_app: :my_app, adapter: Ecto.Adapters.Postgres
  import Ecto.Query, only: [from: 2]

  @moduledoc """
  This module provides functions for reading coupons.
  """

  @doc """
  Retrieves a coupon by ID.

  ## Params

  - `id` (`integer`): The ID of the coupon.

  ## Returns

  - `{:ok, coupon}`: If the coupon is found.
  - `{:error, :coupon_not_found}`: If the coupon is not found.

  ## Examples

  iex> {:ok, coupon} = Tpe.Coupon.Create.create_coupon(%{code: "ABC123", active: true, count: 10, promo_id: 1})
  iex> {:ok, retrieved_coupon} = Tpe.Coupon.Read.get_coupon(coupon.id)
  iex> retrieved_coupon.code
  "ABC123"
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

  ## Examples

  iex> {:ok, _coupon} = Tpe.Coupon.Create.create_coupon(%{code: "ABC123", active: true, count: 10, promo_id: 1})
  iex> {:ok, retrieved_coupon} = Tpe.Coupon.Read.get_coupon_by_code("ABC123")
  iex> retrieved_coupon.code
  "ABC123"
  """
  def get_coupon_by_code(code) do
    code =
      cond do
        Application.fetch_env!(:tpe, :remove_dashes) ->
          String.replace(code, "-", "")

        true ->
          code
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

  ## Params

  - `code` (`string`): The code of the coupon.

  ## Returns

  - `{:ok, coupon}`: If the coupon is valid.
  - `{:error, :coupon_not_active}`: If the coupon is not active.
  - `{:error, :coupon_count_greater_than_max_use}`: If the coupon count is greater than the max_use.
  - `{:error, :coupon_not_found}`: If the coupon is not found.

  ## Examples

  iex> {:ok, _coupon} = Tpe.Coupon.Create.create_coupon(%{code: "ABC123", active: true, count: 0, max_use: 10, promo_id: 1})
  iex> {:ok, coupon} = get_valid_coupon("ABC123")
  iex> coupon.code
  "ABC123"
  """
  def get_valid_coupon(code) do
    case get_coupon_by_code(code) do
      {:ok, coupon} ->
        cond do
          coupon.active != true ->
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

  @doc """
  Retrieves all coupons associated with a given promo_id.

  ## Params
  - `promo_id` (`integer`): The ID of the promo.

  ## Returns
  - A list of coupons associated with the promo_id.

  ## Examples

  iex> {:ok, _coupon1} = Tpe.Coupon.Create.create_coupon(%{code: "ABC123", active: true, count: 10, promo_id: 22})
  iex> {:ok, _coupon2} = Tpe.Coupon.Create.create_coupon(%{code: "DEF456", active: true, count: 5, promo_id: 22})
  iex> coupons = Tpe.Coupon.Read.dump_coupons_by_promo_id(22)
  iex> Enum.reduce(coupons, %{}, fn coupon, acc -> Map.put(acc, coupon.code, coupon.promo_id) end)
  %{"ABC123" => 22, "DEF456" => 22}
  """
  def dump_coupons_by_promo_id(promo_id) do
    Tpe.Repo.all(from(c in Tpe.Coupon, where: c.promo_id == ^promo_id))
  end

  defp add_dashes_to_codes(codes, interv) do
    Enum.map(codes, fn code ->
      String.replace_trailing(String.replace(code, ~r/(.{#{interv}})/, "\\1-"), "-", "")
    end)
  end

  @doc """
  Retrieves coupon codes by promo ID with optional dashes.

  ## Params
  - `promo_id` (`integer`): The ID of the promo.
  - `interv` (`integer`): The interval at which dashes should be added to the coupon codes.

  ## Returns
  - A list of coupon codes with optional dashes added at the specified interval.

  ## Examples

  iex> {:ok, _coupon1} = Tpe.Coupon.Create.create_coupon(%{code: "ABC123", active: true, count: 10, promo_id: 3})
  iex> {:ok, _coupon2} = Tpe.Coupon.Create.create_coupon(%{code: "DEF456", active: true, count: 5, promo_id: 3})
  iex> {:ok, _coupon3} = Tpe.Coupon.Create.create_coupon(%{code: "GHI789", active: true, count: 8, promo_id: 3})
  iex> Tpe.Coupon.Read.dump_coupon_codes_by_promo_id_with_dashes(3)
  ["ABC123", "DEF456", "GHI789"]
  iex> Tpe.Coupon.Read.dump_coupon_codes_by_promo_id_with_dashes(3, 3)
  ["ABC-123", "DEF-456", "GHI-789"]
  """
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
