# Advent of Code - Day 6: Signals and Noise
# Author: Tim Walsh (c) 2016
#
# Elixir solutions for Day 6.
# Run solutions via `iex transceiver.exs`.
#
# Part I Solution:
# => Transceiver.decode_signal("./data/input.txt")
#
defmodule Transceiver do
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

  # 
  def decode_signal(filename) do
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
      |> Enum.sort_by(fn(a) -> List.last(Tuple.to_list a) end, &>=/2)
    end)
    |> Enum.map(fn(list) ->
      list
      |> List.first
      |> Tuple.to_list
      |> List.first
    end)
    |> Enum.join
  end

  # Transceiver.test_decoder
  def test_decoder do
    String.equivalent?(
      Transceiver.decode_signal("./data/test.txt"),
      "easter"
    )
  end
end