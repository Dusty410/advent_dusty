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
        |> with_index_custom()
      end)

    good_updates = all_good_updates(page_rules, page_updates)

    Enum.reduce(good_updates, 0, fn update, acc ->
      acc + get_middle_page_value(update)
    end)
  end

  defp with_index_custom(list) do
    Enum.with_index(list, fn element, index -> {index, element} end)
  end

  defp all_good_updates(page_rules, page_updates) do
    Enum.filter(page_updates, fn update ->
      page_rules
      |> get_relevant_rules(update)
      |> Enum.all?(fn rule -> update_satisfies_rule?(rule, update) end)
    end)
  end

  defp all_bad_updates(page_rules, page_updates) do
    Enum.filter(page_updates, fn update ->
      page_rules
      |> get_relevant_rules(update)
      |> Enum.any?(fn rule -> not update_satisfies_rule?(rule, update) end)
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

  # assume rules are relevant
  # returns scored and sorted rules
  defp map_rule_scores(rules) do
    Enum.map(rules, fn rule ->
      first_rule_score = Enum.count(rules, fn x -> elem(x, 0) == elem(rule, 0) end)
      second_rule_score = Enum.count(rules, fn x -> elem(x, 1) == elem(rule, 1) end)
      {{elem(rule, 0), first_rule_score}, {elem(rule, 1), second_rule_score}}
    end)
    |> Enum.sort_by(fn x -> elem(x, 0) |> elem(1) end, :asc)
    |> Enum.sort_by(fn x -> elem(x, 1) |> elem(1) end, :asc)
  end

  def part2(_) do
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

    all_bad_updates = all_bad_updates(page_rules, page_updates)

    corrected_updates =
      Enum.map(all_bad_updates, fn update ->
        scored_and_sorted_rules =
          page_rules
          |> get_relevant_rules(update)
          |> map_rule_scores()

        unique_rules =
          scored_and_sorted_rules
          |> Enum.uniq_by(fn x -> elem(x, 1) |> elem(1) end)

        first_value = unique_rules |> Enum.at(0) |> elem(0) |> elem(0)

        Enum.reduce(unique_rules, [first_value], fn rule, acc ->
          acc ++ [rule |> elem(1) |> elem(0)]
        end)
        |> with_index_custom()
      end)

    Enum.reduce(corrected_updates, 0, fn update, acc ->
      acc + get_middle_page_value(update)
    end)
  end
end

# sort relevant rules by second rule term's appearance count, ascending
# do unique filter on second rule term
# correct list should be first rule pt 1, first rule pt 2,
# rest are unique values of part 2 of remaining rules
