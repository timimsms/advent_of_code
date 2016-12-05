# Advent of Code - Day 4: Security Through Obscurity
# Author: Tim Walsh (c) 2016
#
# Elixir solutions for Day 4 (Part I).
# Run solutions via `iex sector_checker.exs`.
#
# Part I Solution:
# => SectorChecker.sum_valid_sector_ids("./data/input.txt")
defmodule SectorChecker do
  defmodule Sector do
    defstruct [:name, :sector_id, :checksum]

    # Build Sector from map of corresponding fields.
    def build(map) do
      %Sector{
        name: Map.fetch!(map, "name"),
        sector_id: String.to_integer(Map.fetch!(map, "sector_id")),
        checksum: Map.fetch!(map, "checksum"),
      }
    end

    # Parse a string into a Sector object.
    def parse(str) do
      Regex.named_captures(
        ~r/(?<name>.*-)(?<sector_id>\d*)\[(?<checksum>.*)\]/,
        str
      ) |> Sector.build
    end

    # Recuresively generate a checksum from a scored list of letters
    def gen_checksum([], checksum_array) do
      Enum.join(checksum_array)
    end
    def gen_checksum([head | tail], checksum_array) do
      if length(checksum_array) >= 5 do
        Enum.join(checksum_array)
      else
        key = head |> Tuple.to_list |> List.first
        gen_checksum(
          tail, 
          List.insert_at(
            checksum_array,
            length(checksum_array),
            key
          )
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

    # Transform an array of letters to a 
    def name_to_sorted_list(name) do
      String.replace(name, "-", "")
      |> String.graphemes
      |> Enum.map(fn c -> String.to_atom(c) end)
      |> Sector.reduce_by_letter_count
      |> Map.to_list
      |> Enum.sort_by(fn(a) -> List.last(Tuple.to_list a) end, &>=/2)
    end

    # Valid if the checksum is the five most common letters in the 
    # encrypted name, in order, with ties broken by alphabetization.
    def valid?(sector) do
      Sector.name_to_sorted_list(sector.name)
      |> Sector.gen_checksum([])
      |> String.equivalent?(sector.checksum)
    end
  end

  # SectorChecker.load_sector_data("./data/input.txt")
  def load_sector_data(filename) do
    File.stream!(filename)
    |> Enum.map(fn(str) -> Sector.parse(str) end)
  end

  # SectorChecker.sum_valid_sector_ids("./data/input.txt")
  def sum_valid_sector_ids(filename) do
    load_sector_data(filename)
    |> Enum.reduce(0, fn(sector, acc) ->
      if Sector.valid?(sector) do
        acc + sector.sector_id
      else
        acc
      end
    end)
  end
end
