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

    quote do
      Exkorpion.Server.start 
      Exkorpion.ReportHandler.add :scenario, unquote(name)
      @exkorpion
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
      scenario = unquote(options)
      Exkorpion.ReportHandler.add :test, unquote(name)
      scenario_type = fn
        (%{:with => with_, :given => given_, :when => when_, :then => then_}) -> runTestMultipleScenarios with_, given_, when_, then_
        (%{:given => given_, :when => when_, :then => then_}) -> runTest(given_, when_, then_)
        true -> raise %Exkorpion.Error.InvalidStructureError{}
      end

      try do
         scenario_type.(scenario[:do])
         Exkorpion.ReportHandler.add :result, "success"
      rescue
        e in ExUnit.AssertionError ->  Exkorpion.ReportHandler.add :result, "error"; raise e        
        e in BadFunctionError -> raise %Exkorpion.Error.InvalidStructureError{}
      after
        Exkorpion.ReportHandler.add :test_end, "."  
      end
    end
  end


  def setupGlobalContext ctx do
    Enum.each(ctx, fn {key, value} ->
      Exkorpion.Server.store(key, value)
    end)  

  end


  def run args do
    #ExUnit.configure(exclude: [pending: true])
    #ExUnit.configure(include: [scenario: true])
    
  end


end
