defmodule Exkorpion.Executor do
  

  def runTest context, given_, when_, then_ do
    given_.()
    |> when_.()
    |> then_.()
  end

  def runTestMultipleScenarios context, with_, given_, when_, then_ do
    Enum.each with_.(), fn ctx ->
      given_.(ctx)
      |> joinCtx(ctx)
      |> when_.()
      |> joinCtx(ctx)
      |> then_.()
    end
  end

  defp joinCtx inputCtx, partialCtx do
    Map.merge inputCtx, partialCtx
  end

end