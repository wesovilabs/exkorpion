defmodule Mix.Tasks.Exkorpion do
  use Mix.Task
  
  defdelegate run(args), to: Exkorpion

end