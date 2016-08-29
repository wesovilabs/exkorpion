defmodule Exkorpion.Report.MarkdownHandler do
  use GenEvent

  def handle_event {:scenario, value}, messages do
    {:ok, [value|messages]}
  end

  def handle_call(:messages, messages) do
    {:ok, Enum.reverse(messages), []}
  end

end