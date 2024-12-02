defmodule Advent.Year2024.Day01 do
  def part1(_) do
    day = 1

    split_lists =
      day
      |> Advent.Input.get!()
      |> String.split()
      |> Enum.with_index()
      |> Enum.split_with(fn x -> if elem(x, 1) |> rem(2) == 0, do: elem(x, 0) end)

    left_column =
      elem(split_lists, 0)
      |> Enum.reduce([], fn x, acc ->
        elem = x |> elem(0) |> String.to_integer()
        [elem | acc]
      end)

    right_column =
      elem(split_lists, 1)
      |> Enum.reduce([], fn x, acc ->
        elem = x |> elem(0) |> String.to_integer()
        [elem | acc]
      end)

    left_sorted = Enum.sort(left_column)
    right_sorted = Enum.sort(right_column)

    [left_sorted, right_sorted]
    |> Enum.zip()
    |> Enum.map(fn x -> abs(elem(x, 0) - elem(x, 1)) end)
    |> Enum.sum()
  end

  def part2(_) do
    day = 1

    split_lists =
      day
      |> Advent.Input.get!()
      |> String.split()
      |> Enum.with_index()
      |> Enum.split_with(fn x -> if elem(x, 1) |> rem(2) == 0, do: elem(x, 0) end)

    left_column =
      elem(split_lists, 0)
      |> Enum.reduce([], fn x, acc ->
        elem = x |> elem(0) |> String.to_integer()
        [elem | acc]
      end)

    right_column =
      elem(split_lists, 1)
      |> Enum.reduce([], fn x, acc ->
        elem = x |> elem(0) |> String.to_integer()
        [elem | acc]
      end)

    left_column
    |> Enum.map(fn x -> x * Enum.count(right_column, fn y -> x == y end) end)
    |> Enum.sum()
  end
end
