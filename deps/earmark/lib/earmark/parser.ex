defmodule Earmark.Parser do

  alias Earmark.Line
  alias Earmark.Block


  def parse(text_lines), do: parse(text_lines, false)
  def parse(text_lines, recursive)
  when is_boolean(recursive), do: parse(text_lines, %Earmark.Options{}, recursive)

  def parse(text_lines, options = %Earmark.Options{}, recursive \\ false) do
    # add blank lines before and after
    [ "" | text_lines ++ [""] ] 
    |> Earmark.pmap(fn (line) -> Line.type_of(line, options, recursive) end)
    |> Block.parse
  end

  ################################################################
  # Traverse the block list and extract the footnote definitions #
  ################################################################

  def handle_footnotes(blocks, options, map_func) do
    { footnotes, blocks } = Enum.partition(blocks, &is_footnote_def/1)
    footnotes = map_func.(blocks, &find_footnote_links/1)
                |> List.flatten
                |> get_footnote_numbers(footnotes, options)
    blocks = create_footnote_blocks(blocks, footnotes)
    footnotes = map_func.(footnotes, &({&1.id, &1})) |> Enum.into(HashDict.new)
    { blocks, footnotes }
  end

  defp is_footnote_def(%Block.FnDef{}), do: true
  defp is_footnote_def(_block), do: false

  defp find_footnote_links(%Block.Para{lines: lines}), do: Enum.map(lines, &find_footnote_links/1)

  defp find_footnote_links(line) when is_bitstring(line) do
    Regex.scan(~r{\[\^([^\]]+)\]}, line)
    |> Enum.map(&(tl(&1) |> hd))
  end
  defp find_footnote_links(_), do: []

  def get_footnote_numbers(refs, footnotes, options) do
    Enum.reduce(refs, [], fn(ref, list) ->
      case Enum.find(footnotes, &(&1.id == ref)) do
        note = %Block.FnDef{} -> number = length(list) + options.footnote_offset
                                 note = %Block.FnDef{ note | number: number }
                                 [ note | list ]
        _                     -> list # TODO inline footnotes
      end
    end)
  end

  defp create_footnote_blocks(blocks, []), do: blocks

  defp create_footnote_blocks(blocks, footnotes) do
    footnote_block = %Block.FnList{blocks: Enum.sort_by(footnotes, &(&1.number))}
    Enum.concat(blocks, [footnote_block])
  end
  
end
