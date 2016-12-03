# require Triangle
# 
# Advent of Code - Day 3: Squares With Three Sides
# Author: Tim Walsh (c) 2016
#
# Elixir solutions for Day 3 Part I and II.
# Run solutions via `iex triangle_validator.exs`.
#
# Part I Solution:
# => TriangleValidator.count_valid_triangles_by_row("./data/input.txt")
#
# Part II Solution:
# => TriangleValidator.count_valid_triangles_by_col("./data/input.txt")
defmodule TriangleValidator do
  # Basic representation of a Triangle
  # TODO - move to it's own file once I have a better understanding of Mix.
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

  ## PART I
  # Converts a input file containing triangle measurements into
  # a list of Triangle objects by row.
  def load_triangle_measurements_by_row(filename) do
    Enum.map(
      File.stream!(filename),
      fn(str) -> Triangle.parse(str) end
    )
  end

  # Used to count the total valid triangle given a text 
  # file containing measurement data listed by row.
  def count_valid_triangles_by_row(filename) do
    Enum.count(
      load_triangle_measurements_by_row(filename),
      fn(triangle) -> Triangle.valid?(triangle) end
    )
  end

  ## PART II
  # Converts a input file containing triangle measurements into
  # a list of Triangle objects by column in groups of three.
  def load_triangle_measurements_by_col(filename) do
    Enum.map(
      File.stream!(filename),
      fn(str) -> Triangle.parse(str) end
    )
  end

  # Used to count the total valid triangle given a text 
  # file containing measurement data using column method.
  def count_valid_triangles_by_col(filename) do
    Enum.count(
      load_triangle_measurements_by_col(filename),
      fn(triangle) -> Triangle.valid?(triangle) end
    )
  end
end
