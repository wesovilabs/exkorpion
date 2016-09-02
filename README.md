[![Build Status](https://travis-ci.org/wesovilabs/exkorpion.png)](https://travis-ci.org/wesovilabs/exkorpion)
[![Hex version](https://img.shields.io/hexpm/v/exkorpion.svg "Hex version")](https://hex.pm/packages/exkorpion)
![Hex downloads](https://img.shields.io/hexpm/dt/exkorpion.svg "Hex downloads")

# Exkorpion

**Exkorpion is a framework that will help developers to write tests in a BDD form.**

## Installation

Library is [available in Hex](http://hexdocs.pm/exkorpion), the package can be installed as:

  1. Add `exkorpion` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:exkorpion, "~> 0.0.2-rc.1"}]
    end
    ```

  2. Ensure `exkorpion` is started before your application:

    ```elixir
    def application do
      [applications: [:exkorpion]]
    end
    ```

## Getting started with Exkorpion

Wrapping ExUnit to achieve a BDD syntax for our tests.

Below you can find some very basic examples of how to use  **Exkorpion**


```elixir

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

```
   
    
## How to run

- Make a **scenarios* directory in your project
- Add files with sufix **_scenario.ex** or **_scenario.exs**
- Implementing some test as example above.
- Run  command **MIX_ENV=test mix exkorpion**
    
    
## Project status

- Improving coding style 
- Implementing new functionalities.
- Detecting bugs and fixing them.
- Waitign for feddback.
    

## Contributors

- **Iván Corrales Solera** , <developer@wesovi.com>, [@wesovilabs](https://www.twitter.com/wesovilabs)

## Stable version

**0.0.1** is the stable version