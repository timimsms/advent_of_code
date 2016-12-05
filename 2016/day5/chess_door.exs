# Advent of Code - Day 5: How About a Nice Game of Chess?
# Author: Tim Walsh (c) 2016
#
# Elixir solutions for Day 5 (Parts I & II).
# Run solutions via `iex chess_door.exs`.
#
# Part I Solution:
# => ChessDoor.crack_easy("uqwqemis", 0, "")
#
# Part II Solution:
# => ChessDoor.crack_hard("uqwqemis")
defmodule ChessDoor do
  # Generates an MD5 hash for our purposes.
  def hash(str) do
    :crypto.hash(:md5, str)
    |> Base.encode16
  end

  # Use Regex to determine if there is a valid key.
  def check_hash(hash_str) do
    Regex.named_captures(~r/\b(0{5})(?<key>.)(?<position>.)(.*)/, hash_str)
  end

  # Runs cracking algorithm based on provided input
  # on the "easy" door (i.e., Part I).
  def crack_easy(input, i, result) do
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
        crack_easy(input, (i + 1), "#{result}#{key}")
      else
        crack_easy(input, (i + 1), result)
      end
    end
  end

  # Runs cracking algorithm based on provided input
  # on the "hard" door (i.e., Part II).
  def crack_hard(input, i \\ 0, result \\ "________") do
    unless String.match?(result, ~r/_/) do
      result
    else
      check = check_hash(hash("#{input}#{i}"))
      unless is_nil(check) do
        result_ary = String.graphemes(result)
        key = check["key"]
        pos = String.to_integer(check["position"], 16)
        if (pos <= 7) && (Enum.at(result_ary, pos) == "_") do
          new_result = (result_ary |> List.replace_at(pos, key) |> Enum.join)
          IO.puts new_result
          crack_hard(input, (i + 1), new_result)
        end  
      end
      crack_hard(input, (i + 1), result)
    end
  end
end