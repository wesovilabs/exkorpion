defmodule Exkorpion.Should do
  require Logger	
  import System

  

  @spec should(atom, String.t, String.t)::Boolean
  def should op, left, right do
	
	shouldFn = fn
	    :eq, param1, param2 -> 
	      if (param1 === param2), do: 
	    	{:ok}, 
		  else: 
			{:ko, "Assertion failed", [param1, param2]}
	end
	
	case shouldFn.(op, left, right) do
		{:ok} -> Logger.info "\n Message: Assertion success.\n Expected: #{inspect left}\n Result: #{inspect right}" ;
		{:ko, msg, params} -> Logger.error "\n Message: #{msg}\n Expected: #{inspect left}\n Result: #{inspect right}"; raise %Exkorpion.Error.AssertionError{}
	end
	
  end



end