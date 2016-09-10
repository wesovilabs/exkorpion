defmodule Exkorpion.ConsoleOutputter do
	
  
  @lint false
  ## Just playing this need a very very very BIG re-factor I know it's extremely bad code so far.
  def print_resume do
    IO.puts (IO.ANSI.clear_line)
    IO.puts ("---------------------")
    IO.puts ("|                   |")
    IO.puts (IO.ANSI.format([:cyan, "| Exkorpion resume  |"], true))
    IO.puts ("|                   |")
    IO.puts ("---------------------")
    output = Exkorpion.ReportHandler.output
    Enum.each(output, fn({scenario, value}) ->
      hr = for _ <- 1..(String.length(scenario)+4), do: "-"
      IO.puts (IO.ANSI.clear_line)
      IO.puts "#{hr}"
      IO.puts (IO.ANSI.format([:yellow, "| #{scenario} |"], true))
      IO.puts "#{hr}"
      if length(value) >0 do
        {tests_description, tests_results} = Enum.unzip(value)
        ordered_list= Enum.sort(tests_description,&(String.length(&1) > String.length(&2)))
        longest_test = Enum.at(ordered_list,0)
        max_length = String.length(longest_test) +3
        
        hr = for _ <- 1..max_length+3, do: "-"
        hr2 = for _ <- 1..12, do: "-"
        Enum.each(value, fn({key,value})->
          IO.puts "   #{hr}#{hr2}"
          text = String.pad_trailing(key,max_length-1)
          value_text = result_to_message(value)
          text2 = String.pad_trailing(value_text,9)
          color = color_by_status(value_text)
          [color, "   | #{text} | #{text2} |"]
          |> IO.ANSI.format
          |> IO.puts
          IO.puts "   #{hr}#{hr2}"
          if value_text == "error" do
          	error_code =  Macro.to_string(value.expr)
          	IO.puts (IO.ANSI.clear_line)
          	IO.puts (IO.ANSI.format([:red, "      #{value.message}"]))
          	IO.puts (IO.ANSI.clear_line)
          	IO.puts (IO.ANSI.format([:white, "      code: ", :red, "#{error_code}"]))
          	IO.puts (IO.ANSI.format([:white, "      lhs:  ", :red, "#{value.left}"]))
          	IO.puts (IO.ANSI.format([:white, "      rhs:  ", :red, "#{value.right}"]))
          end
        end)
      end  

    end)
  end

  defp result_to_message(result) when  is_number(result) do
  	if(result === 0) do
  		"success"
  	else
  		"error"		
  	end		
  end

  defp result_to_message(result)  do
  	"error"
  end

  defp color_by_status(status) do
    if(status === "success") do
      :green
    else
      :red  
    end
  end

end