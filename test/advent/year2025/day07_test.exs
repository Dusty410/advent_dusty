defmodule Advent.Year2025.Day07Test do
  use ExUnit.Case

  import Elixir.Advent.Year2025.Day07

  @input ".......S.......\n...............\n.......^.......\n...............\n......^.^......\n...............\n.....^.^.^.....\n...............\n....^.^...^....\n...............\n...^.^...^.^...\n...............\n..^...^.....^..\n...............\n.^.^.^.^.^...^.\n...............\n"

  test "part1" do
    result = part1(@input)

    assert result == 21
  end

  test "part2" do
    result = part2(@input)

    assert result
  end
end
