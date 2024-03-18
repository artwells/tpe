defmodule Tpe.Coupon do
  @moduledoc """
  This module defines the `Tpe.Coupon` schema and provides functions for creating, updating, and retrieving coupons.
  """

  use Ecto.Schema
  use Ecto.Repo, otp_app: :my_app, adapter: Ecto.Adapters.Postgres
  import Ecto.Query, only: [from: 2]
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
    field :inserted_at, :utc_datetime
    field :updated_at, :utc_datetime
  end

  @doc """
  Creates a changeset for a coupon.

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

  @doc """
  Creates a new coupon.

  ## Params

  - `attrs` (`map`): The attributes to create the coupon with.

  ## Returns

  The created coupon.
  """
  def create_coupon(attrs \\ %{}) do
    attrs = Map.put(attrs, :updated_at, DateTime.utc_now())
    %Tpe.Coupon{}
    |> Tpe.Coupon.changeset(attrs)
    |> Tpe.Repo.insert()
  end

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

  @doc """
  Inserts a map of coupons into the database.

  ## Params

  - `coupons` (`list`): The list of coupons to insert.

  ## Returns

  The number of successfully inserted coupons.
  """
  def insert_coupons(coupons) do
    #get the insert_all_timeout value from the application environment
    insert_all_timeout = Application.fetch_env!(:tpe, :chunk_size)
    Tpe.Repo.transaction(fn ->
      Tpe.Repo.insert_all(Tpe.Coupon, coupons, on_conflict: :nothing)
    end, timeout: insert_all_timeout) # Set the timeout value in milliseconds
  end

  @doc """
  Fulfills the count of coupons for a promo.

  This function generates random codes and inserts them into the database until the desired count is reached.

  ## Params

  - `count` (`integer`): The desired count of coupons.
  - `promo_id` (`integer`): The ID of the associated promo.
  - `chunk_size` (`integer`): The maximum number of codes to insert in a single transaction.
  - `max_use` (`integer`): The maximum uses allowed for the codes.

  ## Returns

  - `{:ok, success_count}`: If the count is fulfilled successfully.
  """
  def mass_create(count, promo_id, chunk_size,  max_use, prefix \\ "", suffix \\ "") do
    codes = generate_random_codes(count, promo_id, max_use, prefix, suffix)
    success_count = Enum.reduce(chunk(codes, chunk_size), 0, fn chunk, acc ->
      {:ok, {count, _}} = Tpe.Coupon.insert_coupons(chunk)
      count + acc
    end)
    #recurse if not all codes were inserted
    if success_count < count do
      mass_create(count - success_count, promo_id, max_use, chunk_size)
    end
    {:ok, success_count}
  end

  # Generates random codes for a given count and promo_id.
  #
  # Args:
  #   - count: The number of codes to generate.
  #   - promo_id: The ID of the promo associated with the codes.
  #   - max_use: The maximum uses allowed for the codes.
  # Returns:
  #   A list of maps, each containing a randomly generated code and the promo_id.
  defp generate_random_codes(count, promo_id, max_use, prefix, suffix) do
    cond do
      count <= 0 ->
        []
      true ->
        if(Application.fetch_env!(:tpe, :remove_dashes))
          do
            Enum.map(1..count, fn _ ->
              %{code: String.replace(prefix <> get_single_string() <> suffix, "-", ""), promo_id: promo_id, max_use: max_use}
            end)
          else
      Enum.map(1..count, fn _ ->
        %{code: prefix <> get_single_string() <> suffix, promo_id: promo_id, max_use: max_use}
      end)
    end
  end
  end


  # Generates a single string of random characters based on the configured code characters and length.
  #
  # Examples
  #
  #   iex> get_single_string()
  #   "aBcDeFgH"
  defp get_single_string() do
    characters = Application.fetch_env!(:tpe, :code_characters)
    code_length = Application.fetch_env!(:tpe, :code_length)
    to_string(Enum.map(1..code_length, fn _ -> Enum.random(characters) end))
  end

  # Chunks a list into sublists of a specified size.

  # Examples

  # iex> chunk([1, 2, 3, 4, 5, 6], 2)
  # [[1, 2], [3, 4], [5, 6]]

  # iex> chunk([1, 2, 3, 4, 5, 6], 3)
  # [[1, 2, 3], [4, 5, 6]]

  defp chunk(list, size) when is_list(list) and is_integer(size) and size > 0 do
    Enum.chunk_every(list, size)
  end

  # get all coupons by promo_id
  @doc """
  Retrieves all coupons associated with a given promo_id.

  ## Examples

      iex> Tpe.Coupon.get_coupons_by_promo_id(123)
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


  # Sets the `active` boolean for all coupons associated with a given `promo_id`.
  # Updates the `updated_at` field for the updated coupons.
  #
  # Params:
  #   - `promo_id` (integer): The ID of the promo.
  #   - `active` (boolean): The value to set for the `active` field.
  #
  # Returns:
  #   The number of coupons updated.
  def set_active_by_promo_id(promo_id, active) do
    now = DateTime.utc_now()
   from(c in Tpe.Coupon, where: c.promo_id == ^promo_id,
   update: [set: [active: ^active, updated_at: ^now]])
   |> Tpe.Repo.update_all([])
   end




end
