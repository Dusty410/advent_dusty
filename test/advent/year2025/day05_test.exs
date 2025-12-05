defmodule Advent.Year2025.Day05Test do
  use ExUnit.Case

  import Elixir.Advent.Year2025.Day05

  @input "3-5\n10-14\n16-20\n12-18\n\n1\n5\n8\n11\n17\n32\n"

  test "part1" do
    result = part1(@input)

    assert result == 3
  end

  test "part2" do
    result = part2(@input)

    assert result == 14
  end
end
