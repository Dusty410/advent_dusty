defmodule Advent.Year2025.Day05 do
  def part1(args) do
    {ranges, ids} = condition_input(args)

    Enum.count(ids, &id_in_any_range?(&1, ranges))
  end

  @spec condition_input(input :: String.t()) :: {list(Range.t()), list(non_neg_integer())}
  defp condition_input(input) do
    input
    |> String.split("\n", trim: true)
    |> then(fn list ->
      ranges =
        list
        |> Enum.filter(&String.contains?(&1, "-"))
        |> Enum.map(fn string ->
          string
          |> String.split("-")
          |> then(fn [first, last] -> String.to_integer(first)..String.to_integer(last) end)
        end)

      ids =
        list
        |> Enum.reject(&String.contains?(&1, "-"))
        |> Enum.map(&String.to_integer/1)

      {ranges, ids}
    end)
  end

  @spec id_in_any_range?(id :: non_neg_integer(), ranges :: list(Range.t())) :: boolean()
  defp id_in_any_range?(id, ranges) do
    Enum.any?(ranges, fn range -> id in range end)
  end

  def part2(args) do
    {ranges, _ids} = condition_input(args)

    ranges
    |> clean_ranges()
    |> Enum.map(&Enum.count/1)
    |> Enum.sum()
  end

  defp clean_ranges(ranges, cleaned_ranges \\ []) do
    cleaned_ranges = sort_ranges(cleaned_ranges)

    range = List.first(ranges)
    prev_range = List.last(cleaned_ranges)

    cond do
      all_ranges_disjoint?(cleaned_ranges) and ranges == [] ->
        cleaned_ranges

      is_nil(prev_range) or Range.disjoint?(range, prev_range) ->
        ranges
        |> List.delete(range)
        |> clean_ranges([range | cleaned_ranges])

      range_eclipsed?(range, prev_range) ->
        ranges
        |> List.delete(range)
        |> clean_ranges(cleaned_ranges)

      true ->
        first..last//_step = range
        prev_first..prev_last//_step = prev_range

        if first < prev_first,
          do:
            ranges
            |> List.delete(range)
            |> clean_ranges(clean_ranges([range | cleaned_ranges])),
          else:
            ranges
            |> List.delete(range)
            |> clean_ranges([(prev_last + 1)..last | cleaned_ranges])
    end
  end

  @spec all_ranges_disjoint?(ranges :: list(Range.t())) :: boolean()
  defp all_ranges_disjoint?(ranges) do
    [[nil] ++ [ranges], [ranges] ++ [nil]]
    |> Enum.zip()
    |> Enum.all?(fn {current, next} ->
      is_nil(current) or is_nil(next) or
        Range.disjoint?(current, next)
    end)
  end

  @spec sort_ranges(ranges :: list(Range.t())) :: list(Range.t())
  defp sort_ranges(ranges) do
    ranges
    |> Enum.sort_by(fn first.._last//_step ->
      first
    end)
  end

  @spec range_eclipsed?(range :: Range.t(), check_range :: Range.t()) :: boolean()
  defp range_eclipsed?(range, prev_range) do
    first..last//_step = range
    first in prev_range and last in prev_range
  end
end
