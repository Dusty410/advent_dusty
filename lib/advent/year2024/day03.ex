defmodule Advent.Year2024.Day03 do
  def part1(_) do
    day = 3

    input = Advent.Input.get!(day)

    Regex.scan(~r/mul\([0-9]*,[0-9]*\)/, input)
    |> List.flatten()
    |> Enum.map(fn oper ->
      [a, b] = Regex.scan(~r/[0-9]+/, oper) |> List.flatten()

      String.to_integer(a) * String.to_integer(b)
    end)
    |> Enum.sum()
  end

  def part2(_) do
    day = 3

    input = Advent.Input.get!(day)

    Regex.scan(~r/mul\([0-9]+,[0-9]+\)|do\(\)|don't\(\)/, input)
    |> List.flatten()
    |> Enum.reduce(%{do: true, acc: []}, fn element, %{do: do?, acc: acc} ->
      if do? do
        case element do
          "do()" -> %{do: true, acc: acc}
          "don't()" -> %{do: false, acc: acc}
          _ -> %{do: true, acc: [element | acc]}
        end
      else
        case element do
          "do()" -> %{do: true, acc: acc}
          _ -> %{do: false, acc: acc}
        end
      end
    end)
    |> Map.get(:acc)
    |> Enum.map(fn oper ->
      [a, b] = Regex.scan(~r/[0-9]+/, oper) |> List.flatten()

      String.to_integer(a) * String.to_integer(b)
    end)
    |> Enum.sum()
  end
end
