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

  # def has_abba?(str) do
  # end

  # 
  def supports_tls?(ip) do
    # IO.puts "~> #{ip}\r\n"
    Regex.split(~r{(?<in>\W[\w]*\W)}, ip, on: [:in], include_captures: true)
    |> Enum.each(fn(x) ->
      IO.puts "👍\t~>\t#{x}"
    end)
    Regex.scan(~r{(\W[\w]*\W)}, ip)
    |> Enum.each(fn(x) ->
      IO.puts "👎\t~>\t#{x}"
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