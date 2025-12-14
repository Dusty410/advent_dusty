defmodule Polygon.Line do
  alias Polygon.Line

  @type xy :: {non_neg_integer(), non_neg_integer()}
  @type t :: %__MODULE__{point1: xy(), point2: xy(), orth: :h | :v}

  defstruct [:point1, :point2, :orth]

  @doc """
  Given 2 lines, return true if they intersect. Lines do not intersect if
  either line's endpoint falls exactly on the other line.
  """
  @spec intersect?(line1 :: Line.t(), line2 :: Line.t()) :: boolean()
  def intersect?(%Line{orth: :h} = line1, %Line{orth: :v} = line2) do
    %{point1: {x1, y1}, point2: {x2, _y2}} = line1
    %{point1: {a1, b1}, point2: {_a2, b2}} = line2

    ((x1 < a1 and x2 > a1) or (x2 < a1 and x1 > a1)) and
      ((b1 < y1 and b2 > y1) or (b2 < y1 and b1 > y1))
  end

  def intersect?(%Line{orth: :v} = line1, %Line{orth: :h} = line2) do
    intersect?(line2, line1)
  end

  def intersect?(_line1, _line2), do: false

  @doc """
  Given 2 points, convert to a line struct. If they cannot be converted to a
  vertical or horizontal line, return nil.
  """
  @spec to_line(point1 :: xy(), point2 :: xy()) :: Line.t()
  def to_line({x1, y1} = _point1, {x2, y2} = _point2) when x1 != x2 and y1 != y2, do: nil

  def to_line({x1, y1} = _point1, {x2, y2} = _point2) do
    orth = if x1 == x2, do: :v, else: :h

    if (orth == :h and x1 < x2) or (orth == :v and y1 < y2),
      do: %Line{point1: {x1, y1}, point2: {x2, y2}, orth: orth},
      else: %Line{point1: {x2, y2}, point2: {x1, y1}, orth: orth}
  end
end
