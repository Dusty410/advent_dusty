defmodule Advent.Year2025.Day06Test do
  use ExUnit.Case

  import Elixir.Advent.Year2025.Day06

  @input "123 328  51 64 \n 45 64  387 23 \n  6 98  215 314\n*   +   *   +  \n"

  test "part1" do
    result = part1(@input)

    assert result == 4_277_556
  end

  test "part2" do
    result = part2(@input)

    assert result == 3_263_827
  end
end
