defmodule Advent.Year2025.Day03 do
  def part1(args) do
    args
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(fn digits ->
      list_of_ints =
        digits
        |> String.to_integer()
        |> Integer.digits()

      first_int = find_first_int(list_of_ints)
      second_int = find_second_int(list_of_ints, first_int)
      Integer.undigits([first_int, second_int])
    end)
    |> Enum.sum()
  end

  defp find_first_int(list_of_ints) do
    list_of_ints
    |> List.delete_at(length(list_of_ints) - 1)
    |> Enum.max()
  end

  defp find_second_int(list_of_ints, first_int) do
    list_of_ints
    |> Enum.slice(
      (Enum.find_index(list_of_ints, &(&1 == first_int)) + 1)..(length(list_of_ints) - 1)
    )
    |> Enum.max()
  end

  def part2(args) do
    args
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(fn digits ->
      # [1, 2, 3]
      list_of_ints =
        digits
        |> String.to_integer()
        |> Integer.digits()
        # {value, index}
        |> Enum.with_index()

      list_of_ints
      |> accumulate_ints([])
      |> Enum.map(&elem(&1, 0))
      |> Integer.undigits()
    end)
    |> Enum.sum()
  end

  defp accumulate_ints(list_of_ints, found_ints) do
    left_index = left_index(found_ints)
    right_index = right_index(found_ints)
    # range is inclusive
    found_next_int =
      list_of_ints
      |> Enum.slice(left_index..right_index//1)
      |> Enum.max_by(&elem(&1, 0))

    found_ints = found_ints ++ [found_next_int]

    if length(found_ints) < 12 do
      accumulate_ints(list_of_ints, found_ints)
    else
      found_ints
    end
  end

  defp left_index(found_ints) do
    if found_ints == [], do: 0, else: found_ints |> List.last() |> then(&(elem(&1, 1) + 1))
  end

  defp right_index(found_ints) do
    length(found_ints) - 12
  end
end
