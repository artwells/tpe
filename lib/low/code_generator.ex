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


  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call({:generate_codes, count, promo_id}, _from, state) do
    max_chunk = Map.get(state, :max_chunk)
    Low.Coupon.fulfill_count(count, promo_id, max_chunk)
    {:reply, :ok, state}
  end

  @impl true
  def handle_cast({:generate_codes_async, count, promo_id}, state) do
    max_chunk = Map.get(state, :max_chunk)
    spawn(fn -> Low.Coupon.fulfill_count(count, promo_id, max_chunk) end)
    {:noreply, state}
  end

  # handle cast to resert genserver


end
