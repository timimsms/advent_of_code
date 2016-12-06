# Advent of Code - Day 6: Signals and Noise
# Author: Tim Walsh (c) 2016
#
# Elixir solutions for Day 6.
# Run solutions via `iex transceiver.exs`.
#
# Part I Solution:
# => Transceiver.decode("./data/input.txt", :most_common)
#
# Part I Solution:
# => Transceiver.decode("./data/input.txt", :least_common)
defmodule Transceiver do
  # Minimal testing module.
  defmodule Test do
    # => Transceiver.run_tests
    def run_tests do
      result = (test_decoder_by_mc && test_decoder_by_lc)
      if result do
        IO.puts "All tests pass! 🙌\n"
      else 
        IO.puts "One or more tests have failed... 💩\n"
      end
      result
    end

    ## TESTS
    # Ensures the test input is provided the intended solution
    # when decoding by most common frequency.
    def test_decoder_by_mc do
      String.equivalent?(
        Transceiver.decode("./data/test.txt", :most_common),
        "easter"
      )
    end

    # Ensures the test input is provided the intended solution
    # when decoding by least common frequency.
    def test_decoder_by_lc do
      String.equivalent?(
        Transceiver.decode("./data/test.txt", :least_common),
        "advent"
      )
    end
  end
  
  # Custom reduce method based on letter counts
  def reduce_by_letter_count(enumerable) do
    enumerable
    |> Enum.reduce(%{}, fn (x, acc) ->
      if Map.has_key?(acc, x) do
        Map.update!(acc, x, &(&1 + 1))
      else
        Map.put_new(acc, x, 1)
      end
    end)
  end

  # Defaults to decode by most common. 
  def decode_signal(filename, sort_alg) do
    File.stream!(filename)
    |> Enum.map(fn(str) ->
      str
      |> String.trim_trailing("\n")
      |> String.graphemes
    end)
    |> List.zip
    |> Enum.map(fn(tuple) ->
      tuple
      |> Tuple.to_list
      |> reduce_by_letter_count      
      |> Map.to_list
      |> Enum.sort_by(fn(a) -> List.last(Tuple.to_list a) end, sort_alg)
    end)
    |> Enum.map(fn(list) ->
      list
      |> List.first
      |> Tuple.to_list
      |> List.first
    end)
    |> Enum.join
  end

  # Wrapper to ensure modes are whitelisted
  # valid modes: :most_common, :least_common
  def decode(filename, mode) do
    case mode do
      :most_common -> 
        decode_signal(filename, &>=/2)
      :least_common -> 
        decode_signal(filename, &<=/2)
      _ -> 
        raise "Error: Mode unknown."
    end
  end
end

# Run tests on file load
Transceiver.Test.run_tests
