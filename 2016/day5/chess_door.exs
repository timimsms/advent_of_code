require IEx

# Advent of Code - Day 5: How About a Nice Game of Chess?
# Author: Tim Walsh (c) 2016
#
# Elixir solutions for Day 5.
# Run solutions via `iex chess_door.exs`.
#
# => ChessDoor.crack("uqwqemis", 0, "")
defmodule ChessDoor do
  # Generates an MD5 hash for our purposes.
  # => ChessDoor.hash("abc5278568")
  def hash(str) do
    :crypto.hash(:md5, str)
    |> Base.encode16
  end

  # Use Regex to determine if there is a valid key.
  # ChessDoor.check_hash("00000155F8105DFF7F56EE10FA9B9ABD")
  def check_hash(hash_str) do
    Regex.named_captures(~r/\b(0{5})(?<key>\d)(.*)/, hash_str)
  end

  # Runs cracking algorithm based on provided input.
  def crack(input, i, result) do
    if String.length(result) >= 8 do
      result
    else
      attempt = "#{input}#{i}"
      hash_str = hash(attempt)
      check = check_hash(hash_str)
      unless is_nil(check) do
        key = check["key"]
        IO.puts "#{attempt} => #{hash_str}"
        IO.puts "key found! ~> #{key}"
        crack(input, (i + 1), "#{result}#{key}")
      else
        crack(input, (i + 1), result)
      end
    end
  end

  # ChessDoor.run_test_input
  def run_test_input do
    crack("abc", 0, "")
  end
end