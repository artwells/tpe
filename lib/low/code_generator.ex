defmodule CodeGenerator do
  use GenServer

  @moduledoc """
  Client API for interacting with the CodeGenerator GenServer.
  """

  @doc """
  Starts the CodeGenerator GenServer.
  """
  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
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
  def init(nil) do
    {:ok, %{}}
  end

  @impl true
  def handle_call({:generate_codes, count, promo_id}, _from, state) do
    Low.Coupon.fulfill_count(count, promo_id)
    {:reply, :ok, state}
  end

  @impl true
  def handle_cast({:generate_codes_async, count, promo_id}, state) do
    spawn(fn -> Low.Coupon.fulfill_count(count, promo_id) end)
    {:noreply, state}
  end



end
