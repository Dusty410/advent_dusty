defmodule Advent.Year2025.Day08 do
  @type xyz :: {non_neg_integer(), non_neg_integer(), non_neg_integer()}
  @type point_pair :: {xyz(), xyz()}
  # %{shortest_pairs: list of pairs and distances, circuits: list of lists of points, e.g. [[xyz, xyz], [xyz]]}

  def part1(args, limit \\ 1000) do
    args
    |> condition_input()
    |> find_nearest_pairs([], limit)
  end

  defp condition_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn xyz ->
      xyz
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
  end

  # @spec all_unique_pairs(points :: list(xyz())) :: list({xyz(), xyz()})
  # defp all_unique_pairs(points) do
  #   Enum.reduce(points, [], fn point1, acc ->
  #     Enum.reduce(points, acc, fn point2, acc ->
  #       if {point1, point2} in acc or {point2, point1} in acc,
  #         do: acc,
  #         else: [{point1, point2} | acc]
  #     end)
  #   end)
  # end

  @spec calc_distance(xyz(), xyz()) :: float()
  defp calc_distance({x1, y1, z1}, {x2, y2, z2}) do
    # IO.puts("Calculating distance between (#{x1},#{y1},#{z1} and (#{x2},#{y2},#{z2})")

    :math.sqrt((x2 - x1) ** 2 + (y2 - y1) ** 2 + (z2 - z1) ** 2)
  end

  @spec find_nearest_pairs(
          points :: list(xyz()),
          found :: list({point_pair(), float()}),
          limit :: non_neg_integer()
        ) :: list({point_pair(), float()})
  defp find_nearest_pairs(points, found_pairs, limit)

  defp find_nearest_pairs(_points, found_pairs, limit) when length(found_pairs) >= limit,
    do: found_pairs

  defp find_nearest_pairs(points, found_pairs, already_checked, limit) do
    for point1 <- points, point2 <- points, reduce: [] do
      acc ->
    end
    # next_shortest =
    # Enum.reduce(points, nil, fn point1, acc ->
    #   Enum.reduce(points, acc, fn point2, acc ->
    #     # acc = if is_nil(acc), do: {{point1, point2}, calc_distance(point1, point2)}, else: acc
    #
    #     cond do
    #       point1 == point2 ->
    #         acc
    #
    #       is_nil(acc) ->
    #         {{point1, point2}, calc_distance(point1, point2)}
    #
    #       point_pair_already_found?(found_pairs, {point1, point2}) ->
    #         acc
    #
    #       true ->
    #         {_current_shortest_pair, current_shortest_distance} = acc
    #         new_distance = calc_distance(point1, point2)
    #
    #         if new_distance < current_shortest_distance,
    #           do: {{point1, point2}, new_distance},
    #           else: acc
    #     end
    #   end)
    # end)

    # found_pairs = [next_shortest | found_pairs]
    #
    # found_pairs |> length() |> IO.inspect()
    #
    # find_nearest_pairs(points, found_pairs, limit)
  end

  @spec point_pair_already_found?(found_pairs :: list({point_pair(), float()}), point_pair()) ::
          boolean()
  defp point_pair_already_found?(found_pairs, point_pair) do
    {p1, p2} = point_pair

    Enum.any?(found_pairs, fn {found_point_pair, _distance} ->
      point_pair == found_point_pair or {p2, p1} == found_point_pair
    end)
  end

  def part2(args) do
    args
  end
end
