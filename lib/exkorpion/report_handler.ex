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

  def handle_cast({key,description}, state) do
    new_state = case key do
      :scenario -> state ++ [{description, []}]
      :test -> process_test state, description
      :result -> process_result(state, description)
      _ ->  state
    end
    {:noreply, new_state}
  end

  defp process_test state,description do
    scenarios_length = Enum.count(state)
    {scenarios, current_scenario} = Enum.split(state, scenarios_length - 1)
    current_scenario = Enum.at(current_scenario,0)    
    scenario_tests = elem(current_scenario,1)
    new_scenario_tests = scenario_tests ++ [{description,:result}]
    scenarios ++ [{elem(current_scenario,0),new_scenario_tests}]

  end

  defp process_result state, description do
    scenarios_length = Enum.count(state)
    {scenarios, current_scenario} = Enum.split(state, scenarios_length - 1)
    current_scenario = Enum.at(current_scenario,0)
    current_scenario_tests = elem(current_scenario,1)
    tests_length = Enum.count(current_scenario_tests)
    {current_scenario_tests, current_scenario_current_test} = Enum.split(current_scenario_tests,tests_length - 1)
    current_scenario_current_test = Enum.at(current_scenario_current_test,0)
    updated_current_scenario_current_test = {elem(current_scenario_current_test,0),description}
    updated_scenario = {elem(current_scenario,0), current_scenario_tests ++ [updated_current_scenario_current_test]}
    scenarios ++ [updated_scenario]
  end


  def handle_call({:output}, _from, state) do
  	{:reply,  state, state}
  end

end