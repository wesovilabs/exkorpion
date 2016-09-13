defmodule Exkorpion.MathExamplesTest do
  use Exkorpion

  def sum a, b do
    a + b
  end

  def subs a, b do
    a - b
  end

  scenario "testing sum operation works as expected" do
 
    beforeEach do
      %{a: 12}
    end

    it "does multiple operations depending on vairable input" do

      %{
        with: fn ctx ->
        [
          %{param1: ctx.a, param2: 3, result: 15, op: fn a,b -> sum(a,b) end},
          %{param1: 3, param2: -2, result: 5, op: fn a,b -> subs(a,b) end}
        ]
        end,
        given: fn ctx ->
          %{a: ctx.param1, b: ctx.param2}
        end,
        when: &(%{c: &1.op.(&1.a ,&1.b)}),
        then: fn ctx ->
          assert ctx.c === ctx.result
        end
      }
    end
  end  
  
  
  scenario "testing sum operation works as expected 2" do
    
    beforeEach do
      %{a: 10}
    end

    it "sum positive numbers works as expected" do
      %{
        given: &(%{a: &1.a, b: 3}),
        when: &(%{c: &1.a + &1.b}),
        then: fn ctx ->
          assert ctx.c === 13
        end
      }
    end

    it "sum negative numbers and it should work as expected" do
      %{
        given: &(%{a: &1.a, b: -2}),
        when: &(%{c: sum(&1.a ,&1.b)}),
        then: fn ctx ->
          assert ctx.c === 8
        end
      }
    end

  end

end