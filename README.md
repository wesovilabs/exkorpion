[![Build Status](https://travis-ci.org/wesovilabs/exkorpion.png)](https://travis-ci.org/wesovilabs/exkorpion)
[![Hex version](https://img.shields.io/hexpm/v/exkorpion.svg "Hex version")](https://hex.pm/packages/exkorpion)
![Hex downloads](https://img.shields.io/hexpm/dt/exkorpion.svg "Hex downloads")

# Exkorpion

**An Elixir framework to do testing in a BDD way**

## Installation

Library is [available in Hex](http://hexdocs.pm/exkorpion), the package can be installed as:

  1. Add `exkorpion` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:exkorpion, "~> 0.0.2"}]
    end
    ```


In case of you don't have a elixir environment ready to code, please have a look at the below links:

  - [Elixir installation](http://elixir-lang.org/install.html)
  - [Mix introduction](http://elixir-lang.org/getting-started/mix-otp/introduction-to-mix.html)
  - [Mix dependencies](https://hex.pm/docs/usage)


## Exkorpion goals

  - It wraps ExUnit and enhances their features providing developers with a BDD syntax. 

  - It helps us to write tests wasy-to-read.

  - It is completely compatible with ExUnit.

  - It force us to structure our tests in steps (given-when-then)

  - It is based on a functional syntax, organization our tests steps by anonymous functions.

  - It is not coupled to any other framework.


## Getting started


### Exkorpion syntax

As was mentioned on the above Exkorpion is mainly oriented to a bdd syntax:

**scenario**:  A scenario groups multiple cases that test a functionality works as expected. By using scenario we achieve the below:

  - Better documentation for other developers.
  - Test are better organized and structured
  - Working under an agile methodology we can match scenarios to acceptance criteria

**it**: Exkorpion provide with a reserved word It to represent any of the cases inside a scenario.



  ```elixir

      scenario "testing sum operation works as expected" do

         it "sum positive numbers works as expected" do

         end

         it "sum negative numbers and it should work as expected" do

         end

      end
  ```


**with/given/when/then**: These word are the ones that provide us with s BDD syntax. Actually even when we write some unit tests we should thinkg about them.

  - *Given*: It defines the input data for performing the tests. (It's an optional step, it could be not neccessary sometimes)
  - *When*:  It performs the action to be tested.
  - *Then*:  It ensures the result in the preoviuos step are the expected.


  ```elixir

    it "Ensures that get tracks service returns always 2 elements" do
      %{
        when: fn _ ->
          %{result: build_conn() |> get("/tracks", "v1") |> json_response |> Poison.decode! }
        end,  
        then: fn ctx ->
          assert 2 === length(ctx.result)
        end   
      }
    end
  ```

  we could make us of *with** step if we pretend to run the some tests for multiple input


  ```elixir

    it "Ensures that add new track service works as expected" do
      %{
        with: fn ctx ->
            [
              %{new_track: %{"title" => "Runaway", "singer" => "John Bon Jovi"}},
              %{new_track: %{"title" => "Let her go", "singer" => "The passenger"}},
            ]
        end,
        given: &(%{new_track_json: &1.new_track |> Poison.encode!, previous_tracks: build_conn() |> get("/tracks", "v1") |> json_response |> Poison.decode! }),
        when: fn ctx ->
          %{result: build_conn() |> put_body_or_params(ctx.new_track) |> post("/tracks", "v1") |> json_response |> Poison.decode! }         

        end,  
          then: fn ctx ->
            assert length(ctx.previous_tracks)+1 === length(ctx.result)
            assert true === Enum.member?(ctx.result, ctx.new_track)
          end   
      }
    end
  ```

**beforeEach**: Before each will be inside of a scenario and provices with a reusable set of data for our tests.

  ```elixir

    scenario "testing sum operation works as expected" do
    
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
  ```


### First steps

  - Once we have added exkorpion dependency to our test we can run the below command. This will creae a **scenario** directory on our poejct with a file named **scenario_helper.exs**.

    ```elixir

      mix exkorpion.init
    ```

  - By default **Exkorpion** will search files ended by "**.._scenario.exs**" inside directory scenarios. This could be easyly customized (We explain in following articles.)

  - We can write one or more scenarios per file

  - To run the exkorpion scenarios we just need to run

    ```elixir

      MIX_ENV=test mix exkorpion
    ```
  - Exkorpion provides with a friendly resume about our tests execution.
  
  **Success execution**
  ![exkorpion success](https://github.com/wesovilabs/exkorpion/blob/feature-0.0.2/images/scenario-success.png)


  **Something went wrong!**
  ![exkorpion error](https://github.com/wesovilabs/exkorpion/blob/feature-0.0.2/images/scenario-error.png)   

### Samples

  It's highly recommendable you to have a look at some samples already developed: 

    - [Exkorpion project](https://github.com/wesovilabs/exkorpion/scenarios)
    - [Maru training](https://github.com/wesovilabs/elixir_maru_training/scenarios)


## Contributors

- **Iván Corrales Solera** :  You could reach me by , [email](mailto:developer@wesovi.com), [twitter](https://www.twitter.com/wesovilabs) or [Linkedin](www.linkedin.com/in/ivan-corrales-solera)
