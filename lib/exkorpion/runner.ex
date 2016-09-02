defmodule Exkorpion.Runner do
  use GenServer

  def start do
    GenServer.start(__MODULE__, [], name: __MODULE__)
  end

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def run_scenarios do
    GenServer.cast(__MODULE__, :run_scenarios)
  end


  def handle_cast  :run_scenarios, state , {configuration}do
  	do_run_scenario configuration
  end

  defp do_run_scenario configuration do
  	
  end
end