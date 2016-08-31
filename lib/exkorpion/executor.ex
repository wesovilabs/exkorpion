defmodule Exkorpion.Executor do
  

  def runTest given_, when_, then_ do
    given_.()
    |> when_.()
    |> then_.()
  end

  def runTestMultipleScenarios with_, given_, when_, then_ do
    Enum.each with_.(), fn ctx ->
      given_.(ctx)
      |> Map.merge(ctx)
      |> when_.()
      |> Map.merge(ctx)
      |> then_.()
    end
  end

end