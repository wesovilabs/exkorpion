defmodule Exkorpion.Util do

  def joinCtx inputCtx, partialCtx do
    Map.merge inputCtx, partialCtx
  end

end