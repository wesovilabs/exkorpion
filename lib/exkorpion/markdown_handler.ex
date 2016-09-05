defmodule Exkorpion.MarkdownHandler do
  @moduledoc"""

  """
  use GenServer
  require Logger

  def start do
    GenServer.start(__MODULE__, [], name: :markdown_handler)
  end

  def add(key, description) do
    Logger.info "add:"
    GenServer.cast(:markdown_handler, {key,description})
  end

  def output() do
    Logger.info "Output:"
    GenServer.call(:markdown_handler, {:output})
  end

  def handle_cast({:scenario,description}, state) do
  	new_state = [{:scenario,description} | state]
    {:noreply, Enum.reverse(new_state)}
  end


  def handle_call({:output}, _from, state) do
    Logger.info "Output:"
  	{:reply,  state, state}
  end

end