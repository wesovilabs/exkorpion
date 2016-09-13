defmodule Exkorpion.Executor do
  @moduledoc"""

  """
  
  def run(context, with_, given_, when_, then_ ) when is_nil(with_) do
    sub_context = joinCtx(given_.(context),context)
    sub_context = joinCtx(when_.(sub_context),sub_context, context)
    then_.(sub_context)
  end

  def run(context, with_, given_, when_, then_ ) do
    Enum.each with_.(context), fn ctx ->
      sub_context = joinCtx(given_.(ctx),ctx)
      sub_context = joinCtx(when_.(sub_context),sub_context, ctx)
      then_.(sub_context)
    end

  end


  defp joinCtx firstContext, secondContext, thirdContext do
    joinCtx(joinCtx(firstContext,secondContext),thirdContext)  
  end

  defp joinCtx inputCtx, partialCtx do
    Map.merge  partialCtx, inputCtx
  end

end