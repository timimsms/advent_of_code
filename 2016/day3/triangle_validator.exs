# Advent of Code - Day 3: Squares With Three Sides
# Problem: http://adventofcode.com/2016/day/3
# Solution: TriangleValidator.count_valid_triangles("./data/input.txt")
defmodule TriangleValidator do
  # Basic representation of a Triangle
  defmodule Triangle do
    defstruct a: 1, b: 1, c: 1

    # Builds a Triangle object from an array of three integers
    def build(list) do
      %Triangle{
        a: Enum.at(list, 0),
        b: Enum.at(list, 1),
        c: Enum.at(list, 2)
      }
    end

    # Converts a string of three numbers into a Triangle 
    def parse(lwh) do
      Enum.map(
        String.split(lwh, ~r{\s}, trim: true),
        fn(x) -> String.to_integer(x) end
      ) |> build
    end

    # In a valid triangle, the sum of any two sides must 
    # be larger than the remaining side.
    def valid?(triangle) do
      (triangle.a < (triangle.b + triangle.c )) &&
      (triangle.b < (triangle.c + triangle.a )) &&
      (triangle.c < (triangle.b + triangle.a ))
    end
  end

  # Converts a input file containing triangle measurements into
  # a list of Triangle objects.
  def load_triangle_measurements(filename) do
    Enum.map(
      File.stream!(filename),
      fn(str) -> Triangle.parse(str) end
    )
  end

  # Used to count the total valid triangle given a text 
  # file containing measurement data.
  def count_valid_triangles(filename) do
    Enum.count(
      load_triangle_measurements(filename),
      fn(triangle) -> Triangle.valid?(triangle) end
    )
  end
end
