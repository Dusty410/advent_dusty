defmodule Advent.Year2024.Day04 do
  def part1(_) do
    day = 4

    input = Advent.Input.get!(day)

    conditioned_input =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(
        &(String.split(&1, "", trim: true)
          |> with_index_custom())
      )
      |> with_index_custom()

    Enum.map([0, 45, 90, 135, 180, 225, 270, 315], fn deg ->
      Enum.reduce(conditioned_input, 0, fn row, acc ->
        row
        |> elem(1)
        |> Enum.count(fn col ->
          x = elem(col, 0)
          y = elem(row, 0)
          word_search("XMAS", conditioned_input, x, y, deg)
        end)
        |> Kernel.+(acc)
      end)
    end)
    |> Enum.sum()
  end

  defp with_index_custom(list) do
    Enum.with_index(list, fn element, index -> {index, element} end)
  end

  defp word_search("", _, _, _, _), do: false

  defp word_search(_, _, x, y, _) when x < 0 or y < 0, do: false

  defp word_search(word, list, x, y, deg) do
    found_char = get_char_at(list, x, y)

    cond do
      found_char == "S" and word == "S" ->
        true

      found_char == String.at(word, 0) ->
        {x, y} = get_next_x_y(x, y, deg)

        word
        |> String.slice(1..-1//1)
        |> word_search(list, x, y, deg)

      true ->
        false
    end
  end

  defp get_char_at(_, x, y) when x < 0 or y < 0, do: nil

  defp get_char_at(list, x, y) do
    result =
      case List.keyfind(list, y, 0) do
        result when is_tuple(result) ->
          result
          |> elem(1)
          |> List.keyfind(x, 0)

        result ->
          result
      end

    case result do
      result when is_tuple(result) ->
        result
        |> elem(1)

      _ ->
        nil
    end
  end

  # deg is a degree offset from top of imaginary circle,
  # where word starts at center of circle and is read to the perimeter
  # 0 is top
  # 45 is top right
  # 90 is right
  # 135 is bottom right
  # 180 is bottom
  # 225 is bottom left
  # 270 is left
  # 315 is top left
  defp get_next_x_y(x, y, deg) do
    case deg do
      0 -> {x, y - 1}
      45 -> {x + 1, y - 1}
      90 -> {x + 1, y}
      135 -> {x + 1, y + 1}
      180 -> {x, y + 1}
      225 -> {x - 1, y + 1}
      270 -> {x - 1, y}
      315 -> {x - 1, y - 1}
    end
  end

  def part2(_) do
    day = 4

    input = Advent.Input.get!(day)

    conditioned_input =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(
        &(String.split(&1, "", trim: true)
          |> with_index_custom())
      )
      |> with_index_custom()

    Enum.reduce(conditioned_input, 0, fn row, acc ->
      row
      |> elem(1)
      |> Enum.count(fn col ->
        x = elem(col, 0)
        y = elem(row, 0)

        "A" == get_char_at(conditioned_input, x, y) &&
          word_shape_check(conditioned_input, x, y)
      end)
      |> Kernel.+(acc)
    end)
  end

  # search for "A", when found, start at x-1, y-1 and check for "M"
  # then move CW to x+1, y-1 and check for "M"
  # then move CW to x+1, y+1 and check for "S"
  # then move CW to x-1, y+1 and check for "S"
  # then check for next rotation, starting again at x-1, y-1 and moving CW
  # strings to check are "MMSS", "SMMS", "SSMM", "MSSM"
  defp word_shape_check(list, x, y) do
    top_left = get_char_at(list, x - 1, y - 1)
    top_right = get_char_at(list, x + 1, y - 1)
    bottom_right = get_char_at(list, x + 1, y + 1)
    bottom_left = get_char_at(list, x - 1, y + 1)

    case {top_left, top_right, bottom_right, bottom_left} do
      {"M", "M", "S", "S"} -> true
      {"S", "M", "M", "S"} -> true
      {"S", "S", "M", "M"} -> true
      {"M", "S", "S", "M"} -> true
      _ -> false
    end
  end
end
