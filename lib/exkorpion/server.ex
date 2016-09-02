defmodule Exkorpion.Server do
  @moduledoc"""

  """
  use GenServer
  require Logger

  def start do
    GenServer.start(__MODULE__, %{}, name: :exkorpion_server)
  end

  def store(k, v) do
    GenServer.cast(:exkorpion_server, {:store, k, v})
  end

  def get(k) do
    GenServer.call(:exkorpion_server, {:get, k})
  end

  def get do
    GenServer.call(:exkorpion_server, {:getContext})
  end


  def handle_cast({:store, k, v}, state) do
  	new_state = Map.put(state, k, v)
    {:noreply, new_state}
  end

  def handle_call({:get, k}, _from, state) do
  	{:reply,  Map.get(state, k), state}
  end

  def handle_call({:getContext}, _from, state) do
  	{:reply,  state, state}
  end

end