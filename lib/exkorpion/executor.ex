defmodule Exkorpion.Executor do
  import Exkorpion.Util

  def runTest given_, when_, then_ do
    given_.()
    |> when_.()
    |> then_.()
  end

  def runTestMultipleScenarios with_, given_, when_, then_ do
    Enum.each with_.(), fn ctx ->
      given_.(ctx)
      |> joinCtx(ctx)
      |> when_.()
      |> joinCtx(ctx)
      |> then_.()
    end
  end

end