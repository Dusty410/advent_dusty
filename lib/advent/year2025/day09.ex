defmodule Advent.Year2025.Day09 do
  @type xy :: {non_neg_integer(), non_neg_integer()}

  def part1(args) do
    args
    |> condition_input()
    |> Enum.with_index()
    |> generate_all_areas()
    |> hd()
    |> elem(0)
  end

  defp condition_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn xy ->
      xy
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
  end

  @spec generate_all_areas(indexed_points :: list({xy(), non_neg_integer()})) ::
          list({non_neg_integer(), {non_neg_integer(), non_neg_integer()}})
  defp generate_all_areas(indexed_points) do
    for {p1, i} <- indexed_points,
        {p2, j} <- indexed_points,
        i < j do
      area = calc_area(p1, p2)
      {area, {i, j}}
    end
    |> Enum.sort_by(fn {area, _} -> area end, :desc)
  end

  @spec calc_area(point1 :: xy(), point2 :: xy()) :: non_neg_integer()
  defp calc_area({x1, y1}, {x2, y2}) do
    (1 + abs(x1 - x2)) * (1 + abs(y1 - y2))
  end

  def part2(args) do
    args
  end
end
