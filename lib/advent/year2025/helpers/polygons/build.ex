defmodule Polygon.Build do
  alias Polygon.Line

  @type t :: %__MODULE__{polygon: list(Line.t()), start: Line.xy(), tip: Line.xy()}

  defstruct polygon: [], start: nil, tip: nil
end
