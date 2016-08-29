# Exkorpion

**Exkorpion is a framework that will help developers to write tests in a BDD form.**

## Installation

Library is [available in Hex](http://hexdocs.pm/exkorpion), the package can be installed as:

  1. Add `exkorpion` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:exkorpion, "~> 0.0.1"}]
    end
    ```

  2. Ensure `exkorpion` is started before your application:

    ```elixir
    def application do
      [applications: [:exkorpion]]
    end
    ```

## Getting started with Exkorpion

As was mentioned above Exkorpion is a test framework focused on helping developers to work under BDD.  Then, as you could guess the syntax
will look like Given-When-Then.  

Below you can find some very basic examples of how to use  **Exkorpion**


```elixir
        defmodule ExkorpionDemo.MathOperationsTest do
            use Exkorpion
        
            def sum(a,b) do
                a + b
            end
        
            def subs a, b do
              a - b
            end
            
            scenario "testing sum operation works as expected" do
            
                    it "sum positive numbers works as expected" do
                        %{
                            given: fn -> %{a: 1, b: 2} end,
            
                            when: fn ctx ->
                                %{c: ctx.a + ctx.b}
                            end,
                            then: fn ctx ->
                                assert ctx.c === 3
                            end
                        }
                    end
            
                    it "sum negative numbers and it should work as expected" do
                      %{
                        given: fn  ->
                            %{a: -1, b: -2}
                        end,
                        when: fn ctx ->
                            %{c: sum(ctx.a, ctx.b)}
                        end,
                        then: fn ctx ->
                            assert ctx.c === -3
                        end
                      }
                    end
            
                    it "does multiple operations depending on vairable input" do
            
                      %{
                          with: fn ->
                            [
                                %{param1: 2, param2: 3, result: 5},
                                %{param1: 3, param2: -2, result: 1}
                            ]
                          end,
                          given: fn ctx ->
                            %{a: ctx.param1, b: ctx.param2}
                          end,
                          when: fn ctx ->
                            %{c: sum(ctx.a, ctx.b)}
                          end,
                          then: fn ctx ->
                            assert ctx.c === ctx.result
                          end
                      }
                    end
           end
        end
```
   
    
In order to write new tests with Exkorpion, we need to consider the below:
    
1. Add **use Exkorpion** after module declaration.

2. A **scenario** will be compounds by one of multiple cases, which are represented by **it*

3. So far, we can write two types of tests: 
    
    - We can write basic tests with the required 3 steps: Given, When and Then and the tests will be performed in this order. An example of this
    type of tests can be found in the above example: **it sum positive numbers works as expected** and **it does multiple operations depending on vairable input**
    
    
    - We could extend the test by defining different inputs for the same tests. We can achieve by adding **with** to our map declaration, as we can see in
    **it does multiple operations depending on vairable input**
    
    
## Project status

Just starting with basic functionality to hopefully get some feedback and continue working on new functionalities.
    

## Contributors

- **Iván Corrales Solera** , <developer@wesovi.com>, [@wesovilabs](https://www.twitter.com/wesovilabs)

## Roadmap

Since this project just started as a PoC  there's not yet a real Roadmap,  this will be available very soon.

## Stable version

So far only 0.0.1 version is launched. 