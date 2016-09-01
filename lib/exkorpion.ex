defmodule Exkorpion do
  require Logger
  import Exkorpion.Executor
  import ExUnit.Case
  import ExUnit
  import Exkorpion.Server 
  


  defmacro __using__(args) do
  

    definition =
      quote do
      use ExUnit.Case, unquote(args)
      
      import Exkorpion
      import Logger
      import ExUnit.Callbacks, except: [setup: 1, setup: 2]

      
      def runTest  given_, when_, then_ do
        Exkorpion.Executor.runTest %{}, given_, when_, then_
      end

      def runTestMultipleScenarios with_, given_, when_, then_ do
        Exkorpion.Executor.runTestMultipleScenarios %{}, with_, given_, when_, then_
      end

    end

    [definition]
  end

  defmacro scenario(name, options) do
    quote do
      {:ok, pid} = Exkorpion.Server.start
      Logger.info "Running server on #{inspect pid}"
      ref = Process.monitor(pid)
      Logger.info "* Scenario - #{unquote(name)}"
      test("scenario #{unquote name}", unquote(options))
    end
  end


  defmacro beforeEach(options) do
    setup = 
    quote do
      globalCtx = (unquote(options)[:do])
      setupGlobalContext(globalCtx)
    end  
    [setup]
  end

  defmacro it(name, options) do
    Logger.info "** Case: #{name}"
    #Logger.info "beforeEach: #{inspect unquote(beforeEach)}"
    quote do
    
      scenario = unquote(options)
      value= Exkorpion.Server.get(:a)
      Logger.info "Value from ctx is :a #{inspect value}"
      scenarioType = fn
        (%{:with => with_, :given => given_, :when => when_, :then => then_}) -> runTestMultipleScenarios with_, given_, when_, then_
        (%{:given => given_, :when => when_, :then => then_}) -> runTest(given_, when_, then_)
        true -> raise %Exkorpion.Error.InvalidStructureError{}
      end

      try do
         scenarioType.(scenario[:do])
      rescue
        e in ExUnit.AssertionError  -> raise %Exkorpion.Error.AssertionError{message: e.message}
        e in BadFunctionError -> raise %Exkorpion.Error.InvalidStructureError{}
      end
    end
  end


  def setupGlobalContext ctx do
    Enum.each( ctx, fn {key, value} ->
      Exkorpion.Server.store(key, value)
    end)  

  end

  
  def should(operation, param1, param2) do
    Exkorpion.Should.should operation, param1, param2
  end

end
