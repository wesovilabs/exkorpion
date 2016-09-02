defmodule Exkorpion.Executor do
  @moduledoc"""

  """

  def runTest context, given_, when_, then_ do
    given_.(context)
    |> when_.()
    |> then_.()
  end

  def runTestMultipleScenarios context, with_, given_, when_, then_ do
    Enum.each with_.(context), fn ctx ->
      given_.(ctx)
      |> joinCtx(ctx)
      |> joinCtx(context)
      |> when_.()
      |> joinCtx(ctx)
      |> joinCtx(context)
      |> then_.()
    end
  end

  defp joinCtx inputCtx, partialCtx do
    Map.merge  partialCtx, inputCtx
  end

end