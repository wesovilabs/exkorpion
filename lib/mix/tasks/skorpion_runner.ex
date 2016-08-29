defmodule Exkorpion.ExkorpionRunner do
  use Mix.Task
  use GenEvent

  def run _args do
    {:ok, pid} = GenEvent.start_link([])
    GenEvent.add_handler(pid, Exkorpion.Report.MarkdownHandler, self())
    {:ok, messages} = GenEvent.notify(pid, {:scenario, "pepe"})
  end

end