require IEx

# Check a text file which provides space delimited measurements and
# determine the total number of valid triangles. 
defmodule TriangleValidator do
  # Basic representation of a Triangle
  defmodule Triangle do
    defstruct a: 1, b: 1, c: 1

    def build(list) do
      %Triangle{
        a: Enum.at(list, 0),
        b: Enum.at(list, 1),
        c: Enum.at(list, 2)
      }
    end

    def parse(lwh) do
      Enum.map(
        String.split(lwh, ~r{\s}, trim: true),
        fn(x) -> String.to_integer(x) end
      ) |> build
    end
  end

  # Default usage: TriangleValidator.measurements("./data/input.txt")
  def measurements(filename) do
    Enum.map(
      File.stream!(filename),
      fn(str) -> Triangle.parse(str) end
    )
  end

  # In a valid triangle, the sum of any two sides must 
  # be larger than the remaining side.
  def valid?(triangle) do
    (triangle.a < (triangle.b + triangle.c )) &&
    (triangle.b < (triangle.c + triangle.a )) &&
    (triangle.c < (triangle.b + triangle.a ))
  end

  # Default usage: TriangleValidator.run("./data/input.txt")
  def run(filename) do
    Enum.count(
      measurements(filename),
      fn(triangle) -> valid?(triangle) end
    )
  end
end
