defmodule Advent.Year2025.Day08 do
  @type xyz :: {non_neg_integer(), non_neg_integer(), non_neg_integer()}
  @type indexed_xyz :: {xyz(), non_neg_integer()}

  def part1(args, limit \\ 1000) do
    indexed_points = condition_input(args)

    distances_by_index = indexed_points |> generate_all_distances() |> Enum.slice(0..(limit - 1))

    distances_by_index
    |> join_circuits(indexed_points)
    |> Enum.slice(0..2)
    |> Enum.map(fn circuit -> length(circuit) end)
    |> Enum.reduce(fn length, acc ->
      acc * length
    end)
  end

  @spec condition_input(input :: String.t()) :: list({xyz(), non_neg_integer()})
  defp condition_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn xyz ->
      xyz
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
    |> Enum.with_index()
  end

  @spec generate_all_distances(indexed_points :: list({xyz(), non_neg_integer()})) ::
          {float(), {non_neg_integer(), non_neg_integer()}}
  defp generate_all_distances(indexed_points) do
    for {p1, i} <- indexed_points,
        {p2, j} <- indexed_points,
        i < j do
      dist = calc_distance(p1, p2)
      {dist, {i, j}}
    end
    |> Enum.sort_by(fn {dist, _} -> dist end)
  end

  @spec calc_distance(xyz(), xyz()) :: float()
  defp calc_distance({x1, y1, z1}, {x2, y2, z2}) do
    :math.sqrt((x2 - x1) ** 2 + (y2 - y1) ** 2 + (z2 - z1) ** 2)
  end

  @spec get_point_by_index(indexed_points :: list(indexed_xyz()), non_neg_integer()) :: xyz()
  defp get_point_by_index(indexed_points, target_index) do
    Enum.find(indexed_points, fn {_point, index} ->
      index == target_index
    end)
    |> then(fn {xyz, _index} -> xyz end)
  end

  @spec join_circuits(
          distances_by_index :: list({float(), {non_neg_integer(), non_neg_integer()}}),
          indexed_points :: list({xyz(), non_neg_integer()})
        ) :: list(list(xyz()))
  defp join_circuits(distances_by_index, indexed_points) do
    Enum.reduce(distances_by_index, [], fn {_distance, {i, j}}, circuits ->
      point1 = get_point_by_index(indexed_points, i)
      point2 = get_point_by_index(indexed_points, j)

      connect_point(circuits, point1, point2)
    end)
    |> Enum.sort_by(fn circuit -> length(circuit) end, :desc)
  end

  @spec connect_point(circuits :: list(list(xyz())), point1 :: xyz(), point2 :: xyz()) ::
          list(list(xyz()))
  defp connect_point(circuits, point1, point2) do
    found_circuit1 = find_circuit_with_point(circuits, point1)
    found_circuit2 = find_circuit_with_point(circuits, point2)

    case {found_circuit1, found_circuit2} do
      {nil, nil} ->
        [[point1, point2] | circuits]

      {found_circuit1, nil} ->
        replace_circuit(circuits, found_circuit1, [point2 | found_circuit1])

      {nil, found_circuit2} ->
        replace_circuit(circuits, found_circuit2, [point1 | found_circuit2])

      {found_circuit1, found_circuit2} when found_circuit1 == found_circuit2 ->
        circuits

      {found_circuit1, found_circuit2} ->
        merge_and_replace_circuits(circuits, found_circuit1, found_circuit2)
    end
  end

  @spec find_circuit_with_point(circuits :: list(list(xyz())), xyz()) :: list(xyz())
  defp find_circuit_with_point(circuits, point) do
    Enum.find(circuits, fn circuit ->
      point in circuit
    end)
  end

  defp replace_circuit(circuits, old_circuit, new_circuit) do
    list = List.delete(circuits, old_circuit)
    [new_circuit | list]
  end

  defp merge_and_replace_circuits(circuits, circuit1, circuit2) do
    list = circuits |> List.delete(circuit1) |> List.delete(circuit2)
    [circuit1 ++ circuit2 | list]
  end

  def part2(args) do
    args
  end
end
