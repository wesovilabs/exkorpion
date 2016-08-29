defmodule Exkorpion do
    require Logger
    import Exkorpion.Executor
    import ExUnit.Case


    defmacro __using__(args) do
        definition =
          quote do
            use ExUnit.Case, unquote(args)
            import Exkorpion
            import Logger
            import ExUnit.Callbacks, except: [setup: 1, setup: 2]

            def runTest given_, when_, then_ do
              Executor.runTest given_, when_, then_
            end

            def runTestMultipleScenarios with_, given_, when_, then_ do
                Executor.runTestMultipleScenarios with_, given_, when_, then_
            end
          end


        [definition]
    end

    defmacro scenario(name, options) do
        quote do
            Logger.info "* Scenario - #{unquote(name)}"
            test("scenario #{unquote name}", unquote(options))
        end
    end


    defmacro it(name, options) do
        Logger.info "** Case: #{name}"
        quote do
            scenario = unquote(options)

            scenarioType = fn
              (%{:with => with_, :given => given_, :when => when_, :then => then_}) -> runTestMultipleScenarios with_, given_, when_, then_
              (%{:given => given_, :when => when_, :then => then_}) -> runTest(given_, when_, then_)
              (aux) -> raise %Exkorpion.Error.InvalidStructureError{message: aux}
            end

            try do
               scenarioType.(scenario[:do])
            rescue
                e in ExUnit.AssertionError  -> raise %Exkorpion.Error.AssertionError{message: e.message}
                e in BadFunctionError -> raise %Exkorpion.Error.InvalidStructureError{}
            end

        end
    end




end
