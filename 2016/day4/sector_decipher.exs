# Advent of Code - Day 4: Security Through Obscurity
# Author: Tim Walsh (c) 2016
#
# Elixir solutions for Day 4 (Part II).
# Run solutions via `iex sector_decipher.exs`.
#
# Part II Solution:
# => SectorDecipher.find_northpole_storage("./data/input.txt")
defmodule SectorDecipher do
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

    # Transform an array of letters to a 
    def name_to_sorted_list(name) do
      String.replace(name, "-", " ")
      |> String.graphemes
      |> Enum.map(fn c -> String.to_atom(c) end)
      |> Sector.reduce_by_letter_count
      |> Map.to_list
      |> Enum.sort_by(fn(a) -> List.last(Tuple.to_list a) end, &>=/2)
    end

    # Where codex is the lookup table (typically the alphabet).
    def decipher_name(sector, codex) do
      String.replace(sector.name, "-", " ")
      |> String.graphemes
      |> Enum.map(fn c ->
        if String.equivalent?(c, " ") do
          c
        else
          x = Enum.find_index(codex, fn(x) -> x == c end)
          y = rem((x + sector.sector_id), length(codex))
          Enum.at(
            codex,
            y
          )
        end
      end)
      |> Enum.join
      |> String.trim
    end
  end

  # SectorDecipher.alphabet => ["a", "b", ..., "z"]
  def alphabet do
    String.graphemes("abcdefghijklmnopqrstuvwxyz")
  end

  # SectorDecipher.load_sector_data("./data/input.txt")
  def load_sector_data(filename) do
    File.stream!(filename)
    |> Enum.map(fn(str) -> Sector.parse(str) end)
  end

  # SectorDecipher.decode_rooms("./data/input.txt")
  def decode_rooms(filename) do
    load_sector_data(filename)
    |> Enum.map(fn(sector) ->
      %Sector{
        name: Sector.decipher_name(sector, alphabet),
        sector_id: sector.sector_id,
        checksum: sector.checksum,
      }
    end)
  end

  # SectorDecipher.find_northpole_storage("./data/input.txt")
  def find_northpole_storage(filename) do
    decode_rooms(filename)
    |> Enum.filter(fn(sector) -> 
      String.match?(sector.name, ~r/northpole/)
    end)
  end

  # SectorDecipher.test_decipher
  def test_decipher do
    "qzmt-zixmtkozy-ivhz-343[abxyz]"
    |> Sector.parse
    |> Sector.decipher_name(alphabet)
  end
end
