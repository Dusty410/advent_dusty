defmodule Advent.Year2025.Day02 do
  require Integer

  def part1(args) do
    args
    |> String.trim()
    |> String.split(",")
    |> Enum.map(fn elem ->
      elem
      |> String.split("-")
      |> then(fn [first, last] ->
        Range.new(String.to_integer(first), String.to_integer(last))
      end)
    end)
    |> Enum.flat_map(fn range -> Enum.to_list(range) end)
    |> Enum.filter(fn id -> invalid?(id) end)
    |> Enum.sum()
  end

  @spec invalid?(id :: integer()) :: boolean()
  defp invalid?(id) do
    id_string = Integer.to_string(id)
    id_length = String.length(id_string)

    if Integer.is_odd(id_length) do
      false
    else
      {first, last} = String.split_at(id_string, Integer.floor_div(id_length, 2))
      first == last
    end
  end

  def part2(args) do
    args
    |> String.trim()
    |> String.split(",")
    |> Enum.map(fn elem ->
      elem
      |> String.split("-")
      |> then(fn [first, last] ->
        Range.new(String.to_integer(first), String.to_integer(last))
      end)
    end)
    |> Enum.flat_map(fn range -> Enum.to_list(range) end)
    |> Enum.filter(fn id -> complex_invalid?(id) end)
    |> Enum.sum()
  end

  @spec complex_invalid?(id :: integer()) :: boolean()
  defp complex_invalid?(id) do
    id_string = Integer.to_string(id)
    id_length = String.length(id_string)

    range = 1..Integer.floor_div(id_length, 2)

    if id_length <= 1 do
      false
    else
      Enum.any?(range, fn x ->
        {sub_string, _} = String.split_at(id_string, x)
        test_string = String.duplicate(sub_string, Integer.floor_div(id_length, x))

        test_string == id_string
      end)
    end
  end
end
