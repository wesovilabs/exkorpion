defmodule Exkorpion.Server do
  use GenServer
  require Logger

  def start do
    GenServer.start(__MODULE__, %{}, name: :exkorpion_server)
  end

  def store(k, v) do
  	Logger.info "store #{k}: #{v}"
    GenServer.cast(:exkorpion_server, {:store, k, v})
  end

  def get(k) do
  	Logger.info "get #{k}"
    GenServer.call(:exkorpion_server, {:get, k})
  end


  def handle_cast({:store, k, v}, state) do
  	Logger.info "store"
  	newState = Map.put(state, k, v)
    Logger.info "state #{inspect newState}"
    {:noreply, newState}
  end

  def handle_call({:get, k}, _from, state) do
  	Logger.info "get"
  	{:reply,  Map.get(state, k), state}
  end

end