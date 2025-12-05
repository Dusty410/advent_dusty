defmodule Advent.Year2025.Day04Test do
  use ExUnit.Case

  import Elixir.Advent.Year2025.Day04

  @input "..@@.@@@@.\n@@@.@.@.@@\n@@@@@.@.@@\n@.@@@@..@.\n@@.@@@@.@@\n.@@@@@@@.@\n.@.@.@.@@@\n@.@@@.@@@@\n.@@@@@@@@.\n@.@.@@@.@."

  test "part1" do
    result = part1(@input)

    assert result == 13
  end

  test "part2" do
    result = part2(@input)

    assert result == 43
  end
end
