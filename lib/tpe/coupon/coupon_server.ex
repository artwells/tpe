defmodule Tpe.Coupon.CouponServer do
  use GenServer

  # Client API

  @spec start_link() :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(initial_state \\ %{}) do
    GenServer.start_link(__MODULE__, initial_state, name: __MODULE__)
  end

  def get_coupon(coupon_id) do
    GenServer.call(__MODULE__, {:get_coupon, coupon_id})
  end

  # Server Callbacks

  def init(initial_state) do
    {:ok, initial_state}
  end

  def handle_call({:get_coupon, coupon_id}, _from, state) do
    # Your logic to fetch the coupon
    coupon = Map.get(state, coupon_id, nil)
    {:reply, coupon, state}
  end
end
