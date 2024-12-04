defmodule Advent.Year2024.Day02 do
  def part1(_) do
    day = 2

    day
    |> Advent.Input.get!()
    |> String.split("\n")
    |> Enum.reverse()
    |> tl()
    |> Enum.reverse()
    |> Enum.map(fn x -> String.split(x) |> Enum.map(fn y -> String.to_integer(y) end) end)
    |> Enum.count(fn list ->
      ascending_check(list) or descending_check(list)
    end)
  end

  defp ascending_check(list) do
    list
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn x ->
      first = Enum.fetch!(x, 0)
      last = Enum.fetch!(x, 1)

      first < last and abs(first - last) >= 1 and abs(first - last) <= 3
    end)
  end

  defp descending_check(list) do
    list
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn x ->
      first = Enum.fetch!(x, 0)
      last = Enum.fetch!(x, 1)

      first > last and abs(first - last) >= 1 and abs(first - last) <= 3
    end)
  end

  defp ascending_check_with_safety(list) do
    result =
      list
      |> Enum.with_index()
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.find(fn x ->
        first_with_index = Enum.fetch!(x, 0)
        last_with_index = Enum.fetch!(x, 1)

        first = elem(first_with_index, 0)
        last = elem(last_with_index, 0)

        not (first < last and abs(first - last) >= 1 and abs(first - last) <= 3)
      end)

    case result do
      nil ->
        true

      _ ->
        first_index = Enum.fetch!(result, 0) |> elem(1)
        last_index = Enum.fetch!(result, 1) |> elem(1)

        list |> List.delete_at(first_index) |> ascending_check() ||
          list |> List.delete_at(last_index) |> ascending_check()
    end
  end

  defp descending_check_with_safety(list) do
    result =
      list
      |> Enum.with_index()
      |> Enum.chunk_every(2, 1, :discard)
      |> IO.inspect(charlists: :as_lists, limit: :infinity)
      |> Enum.find(fn x ->
        first_with_index = Enum.fetch!(x, 0)
        last_with_index = Enum.fetch!(x, 1)

        first = elem(first_with_index, 0)
        last = elem(last_with_index, 0)

        not (first > last and abs(first - last) >= 1 and abs(first - last) <= 3)
      end)

    case result do
      nil ->
        true

      _ ->
        first_index = Enum.fetch!(result, 0) |> elem(1)
        last_index = Enum.fetch!(result, 1) |> elem(1)

        list |> List.delete_at(first_index) |> descending_check() ||
          list |> List.delete_at(last_index) |> descending_check()
    end
  end

  def part2(_) do
    day = 2

    day
    |> Advent.Input.get!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn list ->
      String.split(list) |> Enum.map(fn elem -> String.to_integer(elem) end)
    end)
    # |> IO.inspect(charlists: :as_lists, limit: :infinity)
    |> Enum.count(fn list ->
      ascending_check_with_safety(list) or descending_check_with_safety(list)
    end)
  end
end
