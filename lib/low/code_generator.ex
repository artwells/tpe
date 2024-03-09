defmodule CodeGenerator do
  use GenServer


  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(nil) do
    {:ok, %{}}
  end

  @impl true
  def handle_call({:generate_codes, count, promo_id}, _from, state) do
    Low.Coupon.fulfill_count(count, promo_id)
    #IO.puts("Inserted #{success_count} codes")
    {:reply, :ok, state}
  end



end
