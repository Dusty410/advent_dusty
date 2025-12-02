defmodule Advent.Year2025.Day01 do
  # dial indexes are 0 to 99
  def part1(_) do
    day = 1

    result =
      day
      |> Advent.Input.get!()
      |> String.split("\n")
      |> Enum.reject(fn elem -> elem == "" end)
      |> IO.inspect(limit: :infinity)
      |> Enum.reduce(%{index: 50, zero_count: 0}, fn cmd, acc ->
        {dir, cmd_value} = String.split_at(cmd, 1)
        index = Map.get(acc, :index)
        cmd_value = sanitize_cmd_value(dir, cmd_value)

        new_index = wrap(index + cmd_value)
        current_zero_count = Map.get(acc, :zero_count)

        case new_index do
          0 -> Map.merge(acc, %{index: new_index, zero_count: current_zero_count + 1})
          _ -> Map.put(acc, :index, new_index)
        end
      end)

    IO.puts("#{result.zero_count}")
  end

  @spec wrap(cmd_value :: integer()) :: integer()
  defp wrap(cmd_value) when cmd_value < 0 do
    wrap(100 + cmd_value)
  end

  defp wrap(cmd_value) when cmd_value > 99 do
    wrap(cmd_value - 100)
  end

  defp wrap(cmd_value), do: cmd_value

  @spec wrap(cmd_value :: integer(), clicks :: integer(), dir :: :L | :R) :: integer()
  defp wrap(cmd_value, clicks, dir) when cmd_value < 0 do
    IO.inspect(cmd_value: cmd_value, clicks: clicks)
    wrap(cmd_value + 100, clicks + 1, dir)
  end

  defp wrap(cmd_value, clicks, dir) when cmd_value > 99 do
    IO.inspect(cmd_value: cmd_value, clicks: clicks)
    wrap(cmd_value - 100, clicks + 1, dir)
  end

  defp wrap(cmd_value, clicks, dir) when cmd_value == 0 and dir == :L do
    IO.inspect(cmd_value: cmd_value, clicks: clicks)
    {cmd_value, clicks + 1}
  end

  defp wrap(cmd_value, clicks, _dir) do
    IO.inspect(cmd_value: cmd_value, clicks: clicks)
    {cmd_value, clicks}
  end

  # defp wrap(cmd_value, clicks) do
  #   clicks = Integer.floor_div(cmd_value, 100)
  # end

  defp sanitize_cmd_value(dir, cmd_value) do
    cmd_value
    |> String.to_integer()
    |> then(fn cmd_value ->
      case dir do
        :L -> -cmd_value
        :R -> cmd_value
      end
    end)
  end

  def part2(args) do
    input = args

    result =
      input
      |> String.split("\n")
      |> Enum.reject(fn elem -> elem == "" end)
      |> Enum.reduce(%{index: 50, zero_count: 0}, fn cmd, acc ->
        {dir, cmd_value} =
          String.split_at(cmd, 1)
          |> then(fn {dir, cmd_value} -> {String.to_atom(dir), cmd_value} end)

        index = Map.get(acc, :index)
        cmd_value = sanitize_cmd_value(dir, cmd_value)

        clicks = if index == 0 and dir == :L, do: -1, else: 0
        # clicks = 0
        {new_index, clicks} = wrap(index + cmd_value, clicks, dir)
        zero_count = Map.get(acc, :zero_count)

        IO.inspect(
          zero_count: zero_count,
          index: index,
          cmd_value: cmd_value,
          final_index: new_index,
          clicks: clicks
        )

        # case new_index do
        #   0 -> Map.merge(acc, %{index: new_index, zero_count: clicks + zero_count + 1})
        #   _ -> Map.merge(acc, %{index: new_index, zero_count: clicks + zero_count})
        # end

        Map.merge(acc, %{index: new_index, zero_count: clicks + zero_count})
      end)

    result.zero_count
  end
end
