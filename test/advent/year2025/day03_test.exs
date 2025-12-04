defmodule Advent.Year2025.Day03Test do
  use ExUnit.Case

  import Elixir.Advent.Year2025.Day03

  @input "987654321111111\n811111111111119\n234234234234278\n818181911112111"

  test "part1" do
    result = part1(@input)

    assert result == 357
  end

  test "part2" do
    result = part2(@input)

    assert result == 3_121_910_778_619
  end
end
