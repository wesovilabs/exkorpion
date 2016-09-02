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
      #Logger.info "Line: #{inspect __ENV__.line}"
      #Logger.info "Module: #{inspect __ENV__.module}"
      #Logger.info "File: #{inspect __ENV__.file}"
      {_, _} = Exkorpion.Server.start 
        #{:ok, pid2} 
        #{:already_registered, _}
      
      test("scenario #{unquote name}", unquote(options))
      #Logger.info "Running server on #{inspect pid2}"  
      Logger.info "* Scenario - #{unquote(name)}"
      #Exkorpion.Server.terminate  "", :normal
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
    quote do
      scenario = unquote(options)
      value= Exkorpion.Server.get(:a)
      scenarioType = fn
        (%{:with => with_, :given => given_, :when => when_, :then => then_}) -> runTestMultipleScenarios with_, given_, when_, then_
        (%{:given => given_, :when => when_, :then => then_}) -> runTest(given_, when_, then_)
        true -> raise %Exkorpion.Error.InvalidStructureError{}
      end

      try do
         scenarioType.(scenario[:do])
      rescue
        e in ExUnit.AssertionError -> 
          header = Enum.join [__ENV__.module, ", line: ", __ENV__.line] 
          errorMsg = Enum.join ["\n",header, "\n", elem(__ENV__.function,0)]
          Logger.error errorMsg
          Logger.error e.message

        e in Exkorpion.Error.AssertionError -> 
           
          header = Enum.join [__ENV__.module, ", line: ", __ENV__.line] 
          errorMsg = Enum.join ["\n",header, "\n", elem(__ENV__.function,0),e.message]
          Logger.error errorMsg
        
        
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
