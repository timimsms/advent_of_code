# Advent of Code - Day 1: Squares With Three Sides
# Author: Tim Walsh (c) 2017
#
# Elixir solutions for Day 1.
# Run solutions via `iex captcha_solver.exs`.
#
# Solution:
# => CaptchaSolver.run("./data/input.txt")
#
defmodule CaptchaSolver do
  # CaptchaSolver.load("./data/input.txt")
  def load!(filename) do
    File.read!(filename)
  end

  def sum(sequence) do
    case String.length(sequence) do
      1 -> 0
      n when is_integer(n) and n > 1 -> sum_seq(sequence)
    end
  end

  def sum_seq(sequence) do
    sequence  
    |> String.graphemes
    |> Enum.map(fn(x) -> Integer.parse(x) end)
    |> Enum.reduce(fn(x, acc) -> x + acc end)
  end

  # CaptchaSolver.run("./data/input.txt")
  def run(filename) do
    load!(filename)
    |> String.graphemes
    |> Enum.chunk_by(fn(x) -> x end)
    |> Enum.map(fn(x) -> to_string(x) end)
    |> Enum.reduce(fn(s) -> sum(s) end)
  end
end
