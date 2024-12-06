defmodule Advent.Year2024.Day05 do
  def part1(_) do
    day = 5

    input = Advent.Input.get!(day)

    [page_rules, page_updates] =
      input
      |> String.split("\n\n", trim: true)

    page_rules =
      page_rules
      |> String.split("\n", trim: true)
      |> Enum.map(&(String.split(&1, "|", trim: true) |> List.to_tuple()))

    page_updates =
      page_updates
      |> String.split("\n", trim: true)
      |> Enum.map(fn update ->
        update
        |> String.split(",", trim: true)
        |> Enum.with_index(fn element, index -> {index, element} end)
      end)

    good_updates = filter_good_updates(page_rules, page_updates)

    Enum.reduce(good_updates, 0, fn update, acc ->
      acc + get_middle_page_value(update)
    end)
  end

  defp filter_good_updates(page_rules, page_updates) do
    Enum.filter(page_updates, fn update ->
      page_rules
      |> get_relevant_rules(update)
      |> Enum.all?(fn rule -> update_satisfies_rule?(rule, update) end)
    end)
  end

  # rules are assumed to already apply
  defp update_satisfies_rule?(rule, update) do
    first_rule = elem(rule, 0)
    second_rule = elem(rule, 1)

    index_of_first_rule_in_update =
      Enum.find_value(update, fn {index, element} -> if element == first_rule, do: index end)

    index_of_second_rule_in_update =
      Enum.find_value(update, fn {index, element} -> if element == second_rule, do: index end)

    index_of_first_rule_in_update < index_of_second_rule_in_update
  end

  defp rule_applies?(rule, update) do
    first = elem(rule, 0)
    second = elem(rule, 1)

    update_no_indexes =
      update
      |> Enum.unzip()
      |> elem(1)

    first in update_no_indexes and second in update_no_indexes
  end

  defp get_relevant_rules(rules, update) do
    Enum.filter(rules, fn rule -> rule_applies?(rule, update) end)
  end

  defp get_middle_page_value(update) do
    update
    |> Enum.at(((length(update) - 1) / 2) |> round())
    |> elem(1)
    |> String.to_integer()
  end

  def part2(args) do
    args
  end
end
