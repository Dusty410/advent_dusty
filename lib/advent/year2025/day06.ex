defmodule Advent.Year2025.Day06 do
  def part1(args) do
    args
    |> condition_input()
    |> Enum.map(fn equation ->
      equation
      |> perform_operation()
    end)
    |> Enum.sum()
  end

  defp condition_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn string ->
      string
      |> String.split()
      |> Enum.map(fn x ->
        case x do
          "*" -> &Kernel.*/2
          "+" -> &Kernel.+/2
          x -> String.to_integer(x)
        end
      end)
    end)
    |> Enum.zip()
    |> Enum.map(fn equation ->
      op_location = tuple_size(equation) - 1
      operation = elem(equation, op_location)
      terms = equation |> Tuple.delete_at(op_location) |> Tuple.to_list()

      {terms, operation}
    end)
  end

  defp perform_operation(equation) do
    {terms, operation} = equation

    Enum.reduce(terms, fn term, acc ->
      operation.(acc, term)
    end)
  end

  def part2(args) do
    args
  end
end
