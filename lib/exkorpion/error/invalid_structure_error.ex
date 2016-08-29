defmodule Exkorpion.Error.InvalidStructureError do
  defexception message: "Invalid test structure.\n A valid test must contain given-when-then."
end