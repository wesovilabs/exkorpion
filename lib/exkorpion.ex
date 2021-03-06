defmodule Exkorpion do
  @moduledoc"""

  """

  require Logger
  import ExUnit.Case



  defmacro __using__(args) do
  

    definition =
      quote do
      use ExUnit.Case, unquote(args)
      import Exkorpion
      import Logger
      import ExUnit.Callbacks, except: [setup: 1, setup: 2]

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

  defmacro before_each(options) do
    setup = 
    quote do
      global_ctx = (unquote(options)[:do])
      setupGlobalContext(global_ctx)
    end  
    [setup]
  end


  defp step()

  defmacro it(name, options) do
    quote do
      test = unquote(options)
      
      try do
          var_with =  Map.get(test[:do], :with)
          var_given =  Map.get(test[:do], :given, fn _ -> %{} end)
          Exkorpion.Executor.run Exkorpion.Server.get, var_with, var_given, test[:do].when, test[:do].then
          Exkorpion.ReportHandler.add_test_and_result unquote(name), 0
        rescue
          e in ExUnit.AssertionError ->  Exkorpion.ReportHandler.add_test_and_result unquote(name), e; raise e        
          e in BadFunctionError -> Logger.info "#{inspect e}" ; raise %Exkorpion.Error.InvalidStructureError{}
        end
    end
  end


  def setupGlobalContext ctx do
    Enum.each(ctx, fn {key, value} ->
      Exkorpion.Server.store(key, value)
    end)  

  end

  

  


end
