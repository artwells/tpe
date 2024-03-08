defmodule CodeGenerator do
  use GenServer
  @max_codes 10000;
  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(nil) do
    {:ok, %{}}
  end

@impl true
  def handle_call({:generate_codes, count, promo_id}, _from, state) do
    codes = generate_random_codes(count, promo_id)
        Enum.each(chunk(codes, @max_codes), fn chunk ->
           {success_count, _} =Low.Coupon.insert_coupons(chunk)
            IO.puts("Inserted #{success_count} codes")
        end)
        {:reply, :ok, state}
      end

      defp generate_random_codes(count, promo_id) do
        Enum.map(1..count, fn _ ->
          %{code: :crypto.strong_rand_bytes(3) |> Base.encode64(), promo_id: promo_id}
        end)
      end

      defp chunk(list, size) when is_list(list) and is_integer(size) and size > 0 do
        Enum.chunk_every(list, size)
      end

end
