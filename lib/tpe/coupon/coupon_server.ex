defmodule Tpe.Coupon.CouponServer do
  use GenServer

  def init(init_arg) do
    {:ok, init_arg}
  end

  # Client API
  def start_link(initial_state \\ %{}) do
    GenServer.start_link(__MODULE__, initial_state, name: __MODULE__)
  end

  def get_coupon(id), do: GenServer.call(__MODULE__, {:get_coupon, id})

  def get_coupon_by_code(code), do: GenServer.call(__MODULE__, {:get_coupon_by_code, code})

  @spec get_valid_coupon(any()) :: any()
  def get_valid_coupon(code), do: GenServer.call(__MODULE__, {:get_valid_coupon, code})

  def dump_coupons_by_promo_id(promo_id),
    do: GenServer.call(__MODULE__, {:dump_coupons_by_promo_id, promo_id})

  def dump_coupon_codes_by_promo_id_with_dashes(promo_id, interv \\ nil),
    do: GenServer.call(__MODULE__, {:dump_coupon_codes_with_dashes, promo_id, interv})

  # Server Callbacks

  def handle_call({:get_coupon, id}, _from, state) do
    {:reply, get_coupon(id), state}
  end

  def handle_call({:get_coupon_by_code, code}, _from, state) do
    {:reply, get_coupon_by_code(code), state}
  end

  def handle_call({:get_valid_coupon, code}, _from, state) do
    {:reply, get_valid_coupon(code), state}
  end

  def handle_call({:dump_coupons_by_promo_id, promo_id}, _from, state) do
    {:reply, dump_coupons_by_promo_id(promo_id), state}
  end

  def handle_call({:dump_coupon_codes_with_dashes, promo_id, interv}, _from, state) do
    {:reply, dump_coupon_codes_by_promo_id_with_dashes(promo_id, interv), state}
  end
end
