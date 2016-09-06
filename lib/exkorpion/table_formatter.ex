defmodule Exkorpion.TableFormatter do

  import Enum, only: [map: 2, max: 1, zip: 2, join: 2]

  @header ~w(number created_at title)
  @header_column_separator "-+-"

  
  def print_table(rows, header \\ @header) do
    table = rows |> to_table(header)
    header = header |> map(&String.Chars.to_string/1) # the headers needs now to be a string
    columns_widths = [header | table] |> columns_widths

    hr = for _ <- 1..(length(header)), do: "-"

    hr     |> print_row(columns_widths, @header_column_separator)
    header |> print_row(columns_widths)
    hr     |> print_row(columns_widths, @header_column_separator)
    table  |> map &(print_row(&1, columns_widths))
    hr     |> print_row(columns_widths, @header_column_separator)
  end

  def to_table(list_of_dicts, header) do
    list_of_dicts
    |> select_keys(header)
    |> map(fn (dict) ->
      dict
      |> Dict.values
      |> map(&String.Chars.to_string/1)
    end)
  end

  def columns_widths(table) do
    table
    |> Matrix.transpose
    |> map(fn (cell) ->
      cell
      |> map(&String.length/1)
      |> max
    end)
  end

  def select_keys(dict, keys) do
    for entry <- dict do
      {dict1, _} = Dict.split(entry, keys)
      dict1
    end
  end

  def print_row(row, column_widths, separator \\ " | ") do
    padding = separator |> String.to_char_list |> List.first # Hack
    IO.puts  row
    |> zip(column_widths)
    |> map(fn ({ cell, column_width }) ->
      String.ljust(cell, column_width, padding)
    end)
    |> join(separator)
  end
end