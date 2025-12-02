defmodule Advent.Year2025.Day01Test do
  use ExUnit.Case

  import Elixir.Advent.Year2025.Day01

  @tag :skip
  test "part1" do
    input = nil
    result = part1(input)

    assert result
  end

  test "R1000", %{test: test_name} do
    input =
      test_name
      |> Atom.to_string()
      |> String.split("test ")
      |> List.last()

    result = part2(input)

    assert result == 10
  end

  test "R1001", %{test: test_name} do
    input =
      test_name
      |> Atom.to_string()
      |> String.split("test ")
      |> List.last()

    result = part2(input)

    assert result == 10
  end

  test "L1000", %{test: test_name} do
    input =
      test_name
      |> Atom.to_string()
      |> String.split("test ")
      |> List.last()

    result = part2(input)

    assert result == 10
  end

  test "L1001", %{test: test_name} do
    input =
      test_name
      |> Atom.to_string()
      |> String.split("test ")
      |> List.last()

    result = part2(input)

    assert result == 10
  end

  test "L50\nR1", %{test: test_name} do
    input =
      test_name
      |> Atom.to_string()
      |> String.split("test ")
      |> List.last()

    result = part2(input)

    assert result == 1
  end

  test "L50\nL1", %{test: test_name} do
    input =
      test_name
      |> Atom.to_string()
      |> String.split("test ")
      |> List.last()

    result = part2(input)

    assert result == 1
  end

  test "L50\nR1000", %{test: test_name} do
    input =
      test_name
      |> Atom.to_string()
      |> String.split("test ")
      |> List.last()

    result = part2(input)

    assert result == 11
  end

  test "L50\nR1001", %{test: test_name} do
    input =
      test_name
      |> Atom.to_string()
      |> String.split("test ")
      |> List.last()

    result = part2(input)

    assert result == 11
  end

  test "L50\nL1000", %{test: test_name} do
    input =
      test_name
      |> Atom.to_string()
      |> String.split("test ")
      |> List.last()

    result = part2(input)

    assert result == 11
  end

  test "L50\nL1001", %{test: test_name} do
    input =
      test_name
      |> Atom.to_string()
      |> String.split("test ")
      |> List.last()

    result = part2(input)

    assert result == 11
  end
end
