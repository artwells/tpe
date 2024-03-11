defmodule CodeGenerator do
  use GenServer

  @moduledoc """
  Client API for interacting with the CodeGenerator GenServer.
  """

  @doc """
  Starts the CodeGenerator GenServer.
  """
  def start_link() do
    GenServer.start_link(__MODULE__, %{max_chunk: Application.fetch_env!(:low, :max_chunk)}, name: __MODULE__)
  end

  @doc """
  Generates codes by making a synchronous call to the CodeGenerator GenServer.
  """
  def generate_codes(count, promo_id) do
    GenServer.call(__MODULE__, {:generate_codes, count, promo_id})
  end

  @doc """
  Generates codes by making an asynchronous cast to the CodeGenerator GenServer.
  """
  def generate_codes_async(count, promo_id) do
    GenServer.cast(__MODULE__, {:generate_codes_async, count, promo_id})
  end

    @doc """
  Shuts down the CodeGenerator GenServer.
  """
  def shutdown() do
    GenServer.stop(__MODULE__)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  @doc """
  Handles a call to generate codes.

  This function is called when a `:generate_codes` message is received.
  It fulfills the given count of coupons for the specified promo_id using the max_chunk value.

  ## Params

  - `{:generate_codes, count, promo_id}` - A tuple containing the message and its parameters.
  - `_from` - The process that sent the message.
  - `state` - The current state of the process.

  ## Returns

  A tuple `{:reply, :ok, state}` indicating that the call was successful.
  """
  def handle_call({:generate_codes, count, promo_id}, _from, state) do
    max_chunk = Map.get(state, :max_chunk)
    Low.Coupon.fulfill_count(count, promo_id, max_chunk)
    {:reply, :ok, state}
  end

  @impl true
  @doc """
  Generates coupon codes asynchronously.

  This function is called when a `:generate_codes_async` message is cast to the process.
  It spawns a new process that fulfills the given `count` of coupon codes for the specified `promo_id`.
  The `max_chunk` value is retrieved from the `state` map.

  ## Params:
  - `count`: The number of coupon codes to generate.
  - `promo_id`: The ID of the promotion.
  - `state`: The current state of the process.

  ## Returns:
  - `{:noreply, state}`: Indicates that the message has been handled and no reply is expected.
  """
  def handle_cast({:generate_codes_async, count, promo_id}, state) do
    max_chunk = Map.get(state, :max_chunk)
    spawn(fn -> Low.Coupon.fulfill_count(count, promo_id, max_chunk) end)
    {:noreply, state}
  end


end
