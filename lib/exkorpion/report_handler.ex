defmodule Exkorpion.ReportHandler do
  @moduledoc"""
  Report Handler GenServer
  """
  use GenServer
  require Logger

  def start do
    GenServer.start(__MODULE__, [], name: :report_handler)
  end


  def add_scenario_and_tests(scenario, tests) do
    GenServer.cast(:report_handler, {:scenario_with_tests, scenario, tests})
  end

  def add_test_and_result(test, result) do
    GenServer.cast(:report_handler, {:test_with_result, test, result})
  end

  def output() do
    GenServer.call(:report_handler, {:output})
  end

  def handle_cast({:scenario_with_tests, scenario, tests}, state) do
    {:noreply,state ++ [{scenario, tests}]}
  end

  def handle_cast({:test_with_result, test, result}, state) do
    scenario_list = Enum.filter(state, fn(scenario) -> Enum.member?(elem(Enum.unzip(elem(scenario,1)),0),test) end)
    scenario_detail = Enum.at(scenario_list,0)
    result_ele = elem(scenario_detail,1)
    stable_tests = Enum.filter(result_ele, fn(t) -> (elem(t,0) !== test) end)
    tests = stable_tests ++ [{test, result}]
    stable_scenarios = Enum.filter(state, fn(scenario) -> (elem(scenario,0) != elem(scenario_detail,0)) end)
    new_state = stable_scenarios ++ [{elem(scenario_detail,0), tests}]
    {:noreply, new_state}
  end

  def handle_call({:output}, _from, state) do
  	{:reply,  state, state}
  end

end