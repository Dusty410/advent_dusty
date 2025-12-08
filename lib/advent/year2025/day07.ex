defmodule Advent.Year2025.Day07 do
  @type xy :: {non_neg_integer(), non_neg_integer()}

  def part1(args) do
    args
    |> condition_input()
    |> count_splits()
  end

  defp condition_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.filter(fn line -> String.contains?(line, "S") or String.contains?(line, "^") end)
    # |> IO.inspect(limit: :infinity)
    |> Enum.map(fn line ->
      String.split(line, "", trim: true)
      |> Enum.with_index()
      |> Enum.reject(fn {value, _index} ->
        value == "."
      end)
      |> Enum.map(fn {_value, index} -> index end)
      |> MapSet.new()
    end)
    |> then(fn input ->
      splitters = tl(input)
      [start_x] = hd(input) |> MapSet.to_list()

      {start_x, splitters}
    end)
  end

  defp count_splits({start_x, splitters}) do
    splitters
    |> Enum.reduce({0, MapSet.new([start_x])}, fn splitter_line, {count, current_beams} ->
      beams_to_split = MapSet.intersection(splitter_line, current_beams)
      new_splits_count = MapSet.size(beams_to_split) + count
      new_current_beams = split_beams(current_beams, beams_to_split)
      {new_splits_count, new_current_beams}
    end)
    |> then(fn {count, _beams} -> count end)
  end

  @spec split_beams(
          current_beams :: MapSet.t(non_neg_integer()),
          beams_to_split :: MapSet.t(non_neg_integer())
        ) :: MapSet.t(non_neg_integer())
  defp split_beams(current_beams, beams_to_split) do
    Enum.reduce(beams_to_split, current_beams, fn beam, current_beams ->
      current_beams
      |> MapSet.delete(beam)
      |> MapSet.put(beam - 1)
      |> MapSet.put(beam + 1)
    end)
  end

  def part2(args) do
    args
    |> condition_input_complex()
    |> fancy_pascal()
  end

  defp condition_input_complex(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.filter(fn line -> String.contains?(line, "S") or String.contains?(line, "^") end)
    |> Enum.map(fn line ->
      String.split(line, "", trim: true)
      |> Enum.with_index()
      |> Enum.reject(fn {value, _index} ->
        value == "."
      end)
      |> Enum.map(fn {_value, index} -> index end)
    end)
    |> then(fn input ->
      [start_x] = hd(input)
      splitters = tl(input)

      {%{{start_x} => 1}, splitters}
    end)
  end

  defp fancy_pascal({acc, splitters}) do
    Enum.reduce(splitters, acc, fn line, acc ->
      Enum.reduce(line, acc, fn index, acc ->
        if {index} in Map.keys(acc) do
          value = Map.get(acc, {index})
          new_map = Map.delete(acc, {index})

          Map.merge(new_map, %{{index - 1} => value, {index + 1} => value}, fn _k, v1, v2 ->
            v1 + v2
          end)
        else
          acc
        end
      end)
    end)
    |> Map.values()
    |> Enum.sum()
  end
end
