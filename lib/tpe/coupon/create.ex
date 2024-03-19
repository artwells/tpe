defmodule Tpe.Coupon.Create do

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
      {:ok, {count, _}} = Tpe.Coupon.Create.insert_coupons(chunk)
      count + acc
    end)
    #recurse if not all codes were inserted
    if success_count < count do
      mass_create(count - success_count, promo_id, max_use, chunk_size)
    end
    {:ok, success_count}
  end


  # Generates random codes for a given count and promo_id.

  # ## Params

  # - `count` (`integer`): The number of codes to generate.
  # - `promo_id` (`integer`): The ID of the promo associated with the codes.
  # - `max_use` (`integer`): The maximum uses allowed for the codes.
  # - `prefix` (`string`): The prefix to add to each generated code (optional).
  # - `suffix` (`string`): The suffix to add to each generated code (optional).

  # ## Returns

  # A list of maps, each containing a randomly generated code and the promo_id.

  defp generate_random_codes(count, promo_id, max_use, prefix, suffix) do
    cond do
      count <= 0 ->
        []
      true ->
        if(Application.fetch_env!(:tpe, :remove_dashes)) do
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

  # ## Returns

  # A randomly generated string.

  defp get_single_string() do
    characters = Application.fetch_env!(:tpe, :code_characters)
    code_length = Application.fetch_env!(:tpe, :code_length)
    to_string(Enum.map(1..code_length, fn _ -> Enum.random(characters) end))
  end


  # Chunks a list into sublists of a specified size.

  # ## Params

  # - `list` (`list`): The list to be chunked.
  # - `size` (`integer`): The size of each sublist.

  # ## Returns

  # A list of sublists.

  defp chunk(list, size) when is_list(list) and is_integer(size) and size > 0 do
    Enum.chunk_every(list, size)
  end

end
