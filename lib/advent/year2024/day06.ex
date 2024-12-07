defmodule Column do
  @enforce_keys [:col, :value]
  defstruct col: nil, value: nil

  @type t :: %__MODULE__{col: integer(), value: String.t()}

  def to_string(%__MODULE__{value: value}) do
    "#{value}"
  end
end

defmodule Row do
  @enforce_keys [:row, :value]
  defstruct row: nil, value: nil

  @type t :: %__MODULE__{row: integer(), value: Column.t()}

  def to_string(%__MODULE__{value: value}) do
    value
    |> Enum.map(&Column.to_string/1)
    |> Enum.join("")
  end
end

defmodule Guard do
  @enforce_keys [:x, :y, :state]
  defstruct x: nil, y: nil, state: nil

  @type t :: %__MODULE__{x: integer(), y: integer(), state: String.t()}
end

defmodule Advent.Year2024.Day06 do
  def part1(_) do
    map =
      __MODULE__
      |> Atom.to_string()
      |> String.reverse()
      |> String.at(0)
      |> String.to_integer()
      |> Advent.Input.get!()
      |> String.split("\n", trim: true)
      |> Enum.map(
        &(String.split(&1, "", trim: true)
          |> Enum.with_index(fn element, index -> %Column{col: index, value: element} end))
      )
      |> Enum.with_index(fn element, index -> %Row{row: index, value: element} end)

    guard = get_guard(map)

    map = traverse(map, guard)

    print_map(map)

    count_traveled(map)
  end

  defp print_map(map) do
    Enum.map(map, &Row.to_string/1)
    |> Enum.join("\n")
    |> IO.puts()
  end

  defp get_cell_value(map, x, y) do
    Enum.find_value(map, fn row ->
      Enum.find_value(row.value, fn col ->
        if col.col == x and row.row == y, do: col.value
      end)
    end)
  end

  defp set_cell_value(map, x, y, value) do
    Enum.map(map, fn row ->
      col =
        Enum.map(row.value, fn col ->
          if col.col == x and row.row == y, do: %Column{col | value: value}, else: col
        end)

      %Row{row | value: col}
    end)
  end

  @spec get_guard(map :: [Row.t()]) :: Guard.t()
  defp get_guard(map) do
    guard_states = ["^", ">", "v", "<"]

    Enum.find_value(map, fn row ->
      Enum.find_value(row.value, fn col ->
        if Enum.member?(guard_states, col.value),
          do: %Guard{x: col.col, y: row.row, state: col.value}
      end)
    end)
  end

  # returns updated map and guard
  defp put_guard(map, x, y, guard_state) do
    map = set_cell_value(map, x, y, guard_state)

    {map, %Guard{x: x, y: y, state: guard_state}}
  end

  defp traverse(map, guard) do
    %Guard{x: x_for_marker, y: y_for_marker} = guard

    if not guard_gone?(map, guard) do
      {map, guard} = if obstacle?(map, guard), do: rotate_guard(map, guard), else: {map, guard}
      {new_x, new_y} = get_guard_next_cell_coords(guard)
      {map, guard} = put_guard(map, new_x, new_y, guard.state)
      map = place_traveled_marker(map, x_for_marker, y_for_marker)

      traverse(map, guard)
    else
      map
    end
  end

  # checks if guard is facing an obstacle
  defp obstacle?(map, guard) do
    {x, y} = get_guard_next_cell_coords(guard)

    get_cell_value(map, x, y) == "#"
  end

  # returns new x, y of cell guard is facing
  defp get_guard_next_cell_coords(guard) do
    %Guard{x: x, y: y, state: guard_state} = guard

    case guard_state do
      "^" -> {x, y - 1}
      ">" -> {x + 1, y}
      "v" -> {x, y + 1}
      "<" -> {x - 1, y}
    end
  end

  # rotates guard cw and returns updated map and guard
  defp rotate_guard(map, guard) do
    %Guard{x: x, y: y, state: guard_state} = guard

    guard_state =
      case guard_state do
        "^" -> ">"
        ">" -> "v"
        "v" -> "<"
        "<" -> "^"
      end

    put_guard(map, x, y, guard_state)
  end

  # checks if guard has left the map
  defp guard_gone?(map, guard) do
    is_nil(get_cell_value(map, guard.x, guard.y))
  end

  defp place_traveled_marker(map, x, y) do
    set_cell_value(map, x, y, "X")
  end

  defp count_traveled(map) do
    map
    |> Enum.map(fn row -> Enum.count(row.value, fn col -> col.value == "X" end) end)
    |> Enum.sum()
  end

  def part2(args) do
    args
  end
end
