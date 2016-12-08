require IEx

# Advent of Code - Day 6: Signals and Noise
# Author: Tim Walsh (c) 2016
#
# Elixir solutions for Day 7.
# Run solutions via `iex ip_scanner.exs`.
defmodule IpScanner do
  # Minimal testing module.
  defmodule Test do
    # abba[mnop]qrst supports TLS
    # abcd[bddb]xyyx does not support TLS
    # aaaa[qwer]tyui does not support TLS
    # ioxxoj[asdfgh]zxcvbn supports TLS
    def run_examples do
      (IpScanner.supports_tls?("abba[mnop]qrst")) &&
      (IpScanner.supports_tls?("abcd[bddb]xyyx") == false) &&
      (IpScanner.supports_tls?("aaaa[qwer]tyui") == false) &&
      (IpScanner.supports_tls?("ioxxoj[asdfgh]zxcvbn"))
    end
  end

  # true if contains ABBA
  # IpScanner.contains_abba?("abba") => true
  # IpScanner.contains_abba?("abcd") => false
  # IpScanner.contains_abba?("aaaa") => false
  # IpScanner.contains_abba?("ioxxoj") => true
  def contains_abba?(left, right) do
    IO.puts "contains_abba?(left, right)"
    IO.puts "\tleft:\t#{left}"
    IO.puts "\tright:\t#{right}"
    (left != right) && (left == String.reverse(right))
  end
  def contains_abba?(str) do
    IO.puts "contains_abba?(str)"
    if String.length(str) <= 1 do
      false
    else
      {left, right} = String.split_at(str, div(String.length(str), 2))
      contains_abba?(left, right)
      || contains_abba?(String.slice(str, 1..(String.length(str)-2)))
    end
  end

  # true if has_abba?(str) == expected_bool
  def assert_abba_val(str, expected_bool) do
    result = contains_abba?(str)
    IO.puts "[#{result}] => #{str} should be #{expected_bool}"
    result == expected_bool
  end

  # true if contains ABBA and is not within brackets
  def valid_abba?(str) do
    if String.starts_with?(str, "[")  do
      str
      |> String.trim_leading("[")
      |> String.trim_trailing("]")
      |> assert_abba_val(false)
    else
      str
      |> assert_abba_val(true)
    end
  end

  # 
  def supports_tls?(ip) do
    IO.puts "#{ip}\r\n"
    Regex.split(~r{(?<in>\W[\w]*\W)}, ip, on: [:in], include_captures: true)
    |> Enum.each(fn(x) ->
      String.trim(x, "\n")
      |> valid_abba?
    end)
    IO.puts "\r\n- - - - - - -\r\n"
  end

  # IpScanner.count_valid_ips("./data/input.txt")
  def count_valid_ips(filename) do
    File.stream!(filename)
    |> Enum.map(fn(ip) -> supports_tls?(ip) end)
    # |> Enum.reduce(0, fn(ip, acc) ->
    #   if supports_tls?(ip) do
    #     1 + acc
    #   end
    # end)
  end
end