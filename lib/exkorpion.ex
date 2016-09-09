defmodule Exkorpion do
  @moduledoc"""

  """

  require Logger
  import Exkorpion.Executor
  import ExUnit.Case
  import ExUnit
  import Exkorpion.Server 
  import Exkorpion.ReportHandler



  defmacro __using__(args) do
  

    definition =
      quote do
      use ExUnit.Case, unquote(args)
      import Exkorpion
      import Logger
      import ExUnit.Callbacks, except: [setup: 1, setup: 2]

      def runTest  given_, when_, then_ do
        Exkorpion.Executor.runTest Exkorpion.Server.get, given_, when_, then_
      end

      def runTestMultipleScenarios with_, given_, when_, then_ do
        Exkorpion.Executor.runTestMultipleScenarios Exkorpion.Server.get, with_, given_, when_, then_
      end

    end

    [definition]
  end

  defmacro scenario(name, options) do

    block = quote do 
      unquote options
    end

    tests_in_scenario = block
    |> Macro.to_string
    |> (fn text -> Regex.scan ~r/it\((.)+\"/, text end).()
    |> (fn list -> Enum.map(list, fn sub_list -> "it(" <> definition  =  Enum.at(sub_list,0); {String.replace(definition,"\"",""), :result} end) end).()
    
    quote do
      Exkorpion.Server.start 
      Exkorpion.ReportHandler.add_scenario_and_tests  unquote(name), unquote(tests_in_scenario)
      test("scenario #{unquote name}", unquote(options))
    end
  end

  defmacro beforeEach(options) do
    setup = 
    quote do
      global_ctx = (unquote(options)[:do])
      setupGlobalContext(global_ctx)
    end  
    [setup]
  end

  defmacro it(name, options) do
    quote do
      test = unquote(options)


      scenario_type = fn
        (%{:with => with_, :given => given_, :when => when_, :then => then_}) -> runTestMultipleScenarios with_, given_, when_, then_
        (%{:given => given_, :when => when_, :then => then_}) -> runTest(given_, when_, then_)
        true -> raise %Exkorpion.Error.InvalidStructureError{}
      end
      
      try do
          scenario_type.(test[:do])
          Exkorpion.ReportHandler.add_test_and_result unquote(name), "success"
        rescue
          e in ExUnit.AssertionError ->  Exkorpion.ReportHandler.add_test_and_result unquote(name), "error"; raise e        
          e in BadFunctionError -> raise %Exkorpion.Error.InvalidStructureError{}
        end
    end
  end


  def setupGlobalContext ctx do
    Enum.each(ctx, fn {key, value} ->
      Exkorpion.Server.store(key, value)
    end)  

  end


  def run args do
    ExUnit.configure(exclude: [pending: true])
    ExUnit.configure(include: [scenario: true])
    ExUnit.run args
  end


end
