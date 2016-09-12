defmodule Exkorpion.Executor do
  @moduledoc"""

  """
  
  def run(context, with_, given_, when_, then_ ) when is_nil(with_) do
    context
      |> given_.()
      |> joinCtx(context)
      |> when_.()
      |> joinCtx(context)
      |> then_.()
  end

  def run(context, with_, given_, when_, then_ ) do
    Enum.each with_.(context), fn ctx ->
      ctx
      |> given_.()
      |> joinCtx(ctx,context)
      |> when_.()
      |> joinCtx(ctx, context)
      |> then_.()
    end

  end

  

  defp joinCtx firstContext, secondContext, thirdContext do
    joinCtx(joinCtx(firstContext,secondContext),thirdContext)  
  end

  defp joinCtx inputCtx, partialCtx do
    Map.merge  partialCtx, inputCtx
  end

end