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
    list
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn x ->
      first = Enum.fetch!(x, 0)
      last = Enum.fetch!(x, 1)

      if first < last and abs(first - last) >= 1 and abs(first - last) <= 3 do
        true
      else
        list |> List.delete(first) |> ascending_check() ||
          list |> List.delete(last) |> ascending_check()
      end
    end)
  end

  defp descending_check_with_safety(list) do
    result =
      list
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.all?(fn x ->
        first = Enum.fetch!(x, 0)
        last = Enum.fetch!(x, 1)

        first > last and abs(first - last) >= 1 and abs(first - last) <= 3
        # if first > last and abs(first - last) >= 1 and abs(first - last) <= 3 do
        #   true
        # else
        #   list |> List.delete(first) |> descending_check() ||
        #     list |> List.delete(last) |> descending_check()
        # end
      end)

      # if result 
  end

  # defp success_or_culprits(list) do
  #   
  # end

  def part2(_) do
    day = 2

    day
    |> Advent.Input.get!()
    |> String.split("\n")
    |> Enum.reverse()
    |> tl()
    |> Enum.reverse()
    |> Enum.map(fn x ->
      String.split(x) |> Enum.map(fn y -> String.to_integer(y) end)
    end)
    |> Enum.count(fn list ->
      ascending_check_with_safety(list) or descending_check_with_safety(list)
    end)
  end
end
