defmodule Advent.Year2025.Day04 do
  @type x :: integer()
  @type y :: integer()
  @type point :: {x(), y()}
  @type point_map :: MapSet.t(point())

  def part1(args) do
    point_map = condition_input(args)

    Enum.count(point_map, fn point ->
      not too_many_neighbors?(point, point_map)
    end)
  end

  @spec condition_input(input :: String.t()) :: MapSet.t(point())
  defp condition_input(input) do
    input
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    # add row (y) indexes
    |> Enum.with_index()
    |> Enum.map(fn {line, y_index} ->
      line
      |> String.graphemes()
      # add column (x) indexes
      |> Enum.with_index()
      |> Enum.filter(fn {value, _index} -> value == "@" end)
      |> build_map_set(y_index)
    end)
    |> Enum.reduce(fn line_map, acc ->
      MapSet.union(acc, line_map)
    end)
  end

  @spec build_map_set(line :: list({String.t(), x()}), y_index :: y()) ::
          MapSet.t(point())
  defp build_map_set(line, y_index) do
    Enum.reduce(line, MapSet.new(), fn {_value, x_index}, acc ->
      MapSet.put(acc, {x_index, y_index})
    end)
  end

  @spec too_many_neighbors?(point :: point(), point_map :: point_map()) :: boolean()
  defp too_many_neighbors?(point, %MapSet{} = point_map) do
    point
    |> neighbor_coords()
    |> Enum.count(fn point ->
      MapSet.member?(point_map, point)
    end)
    |> then(&(&1 >= 4))
  end

  @spec neighbor_coords(point :: point()) :: list(point())
  defp neighbor_coords(point) do
    {x, y} = point

    Code.eval_string("""
    [
     {#{x - 1}, #{y - 1}}, {#{x}, #{y - 1}}, {#{x + 1}, #{y - 1}},
     {#{x - 1}, #{y}},                       {#{x + 1}, #{y}},
     {#{x - 1}, #{y + 1}}, {#{x}, #{y + 1}}, {#{x + 1}, #{y + 1}},
    ]
    """)
    |> then(fn {result, _binding} -> result end)
  end

  def part2(args) do
    args
    |> condition_input()
    |> count_and_remove_points(0)
  end

  @spec count_and_remove_points(point_map :: point_map(), acc :: non_neg_integer()) ::
          non_neg_integer()
  defp count_and_remove_points(point_map, acc) do
    new_point_map =
      point_map
      |> Enum.reject(fn point -> not too_many_neighbors?(point, point_map) end)
      |> MapSet.new()

    points_removed = MapSet.size(point_map) - MapSet.size(new_point_map)

    if points_removed > 0 do
      count_and_remove_points(new_point_map, acc + points_removed)
    else
      acc
    end
  end
end
