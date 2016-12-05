require IEx

# Advent of Code - Day 4: Security Through Obscurity
# Author: Tim Walsh (c) 2016
#
# Elixir solutions for Day 4.
# Run solutions via `iex sector_checker.exs`.
#
# Solution:
# => SectorChecker.sum_valid_sector_ids("./data/input.txt")
defmodule SectorChecker do
  defmodule Sector do
    defstruct [:name, :sector_id, :checksum]

    def build(map) do
      %Sector{
        name: Map.fetch!(map, "name"),
        sector_id: String.to_integer(Map.fetch!(map, "sector_id")),
        checksum: Map.fetch!(map, "checksum"),
      }
    end

    def parse(str) do
      Regex.named_captures(
        ~r/(?<name>.*-)(?<sector_id>\d*)\[(?<checksum>.*)\]/,
        str
      ) |> Sector.build
    end

    # Recuresively generate a checksum from a list of letters
    def generate_checksum([head | tail], map, checksum) do
      if Kernel.length(checksum) < 5 do
        IEx.pry
      else

      end
    end
    
    def generate_checksum([], map, checksum) do
      checksum
    end

    def valid?(sector) do
      String.replace(sector.name, "-", "")
      |> String.graphemes
      |> Enum.map(fn c -> String.to_atom(c) end)
      |> Enum.reduce(%{},
        fn (x, acc) ->
          if Map.has_key?(acc, x) do
            Map.update!(acc, x, &(&1 + 1))
          else
            Map.put_new(acc, x, 1)
          end
        end)
      |> Sector.generate_checksum("")
    end
  end

  def load_sector_data(filename) do
    File.stream!(filename)
    |> Enum.map(fn(str) -> Sector.parse(str) end)
  end

  # SectorChecker.sum_valid_sector_ids("./data/input.txt")
  def sum_valid_sector_ids(filename) do
    load_sector_data(filename)
    |> Enum.reduce(0, fn(sector, acc) -> 
      if Sector.valid?(sector), do: acc + sector.sector_id
    end)
  end

  # SectorChecker.test_valid?
  def test_valid? do
    "not-a-real-room-404[oarel]"
    |> Sector.parse
    |> Sector.valid?
  end
end
