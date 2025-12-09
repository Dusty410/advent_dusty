defmodule Advent.Year2025.Day09Test do
  use ExUnit.Case

  import Elixir.Advent.Year2025.Day09

  @input "7,1\n11,1\n11,7\n9,7\n9,5\n2,5\n2,3\n7,3\n"

  test "part1" do
    result = part1(@input)

    assert result == 50
  end

  test "part2" do
    result = part2(@input)

    assert result
  end
end
