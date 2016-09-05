defmodule Exkorpion.ReportHandler do
  @moduledoc"""

  """
  use GenServer
  require Logger

  def start do
    GenServer.start(__MODULE__, [], name: :report_handler)
  end

  def add(key, description) do
    GenServer.cast(:report_handler, {key,description})
  end

  def output() do
    GenServer.call(:report_handler, {:output})
  end

  def handle_cast({:scenario,description}, state) do
  	new_state = [{:scenario,description} | state]
    {:noreply, Enum.reverse(new_state)}
  end


  def handle_call({:output}, _from, state) do
  	{:reply,  state, state}
  end

end