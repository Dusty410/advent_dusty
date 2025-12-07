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
    |> condition_input_complex()
    |> Enum.map(fn equation ->
      equation
      |> perform_operation()
    end)
    |> Enum.sum()
  end

  defp condition_input_complex(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&(String.reverse(&1) |> String.split("", trim: true)))
    |> Enum.zip()
    |> Enum.map(fn tuple ->
      tuple |> Tuple.to_list() |> List.to_string() |> String.trim()
    end)
    |> Enum.chunk_by(&(&1 == ""))
    |> Enum.reject(&(&1 == [""]))
    |> Enum.map(fn terms ->
      operator_string = terms |> List.last() |> String.last()

      operation =
        case operator_string do
          "*" -> &Kernel.*/2
          "+" -> &Kernel.+/2
        end

      terms =
        terms
        |> Enum.map(fn term ->
          if String.contains?(term, operator_string) do
            term
            |> String.split(operator_string)
            |> hd()
            |> String.trim()
            |> String.to_integer()
          else
            term |> String.trim() |> String.to_integer()
          end
        end)

      {terms, operation}
    end)
  end
end
