defmodule Advent.Year2025.Day09 do
  alias Polygon.Line
  alias Polygon.Build

  def part1(args) do
    args
    |> condition_input()
    |> Enum.with_index()
    |> generate_all_areas()
    |> hd()
    |> elem(0)
  end

  defp condition_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn xy ->
      xy
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
  end

  @spec generate_all_areas(indexed_points :: list({Line.xy(), non_neg_integer()})) ::
          list({non_neg_integer(), {non_neg_integer(), non_neg_integer()}})
  defp generate_all_areas(indexed_points) do
    for {p1, i} <- indexed_points,
        {p2, j} <- indexed_points,
        i < j do
      area = calc_area(p1, p2)
      {area, {i, j}}
    end
    |> Enum.sort_by(fn {area, _} -> area end, :desc)
  end

  # a rectangle is just a list of 4 lines
  @spec generate_all_rectangles(indexed_points :: list({Line.xy(), non_neg_integer()})) ::
          list(Line.t())
  defp generate_all_rectangles(indexed_points) do
    for {p1, i} <- indexed_points,
        {p2, j} <- indexed_points,
        i < j do
      {x1, y1} = p1
      {x2, y2} = p2

      if x1 != x2 and y1 != y2 do
        p3 = {x1, y2}
        p4 = {x2, y1}

        line1 = Line.to_line(p1, p3)
        line2 = Line.to_line(p1, p4)
        line3 = Line.to_line(p2, p3)
        line4 = Line.to_line(p2, p4)

        [line1, line2, line3, line4]
      end
    end
    |> Enum.reject(&is_nil/1)
  end

  @spec calc_area(point1 :: Line.xy(), point2 :: Line.xy()) :: non_neg_integer()
  defp calc_area({x1, y1}, {x2, y2}) do
    (1 + abs(x1 - x2)) * (1 + abs(y1 - y2))
  end

  @spec calc_rect_area(rectangle :: list(Line.t())) :: non_neg_integer()
  defp calc_rect_area(rectangle) do
    points =
      rectangle
      |> Enum.flat_map(fn %Line{point1: p1, point2: p2} -> [p1, p2] end)
      |> Enum.uniq()

    [{x1, y1} = point1 | _] = points

    point2 =
      Enum.find(points, fn {x2, y2} ->
        x1 != x2 and y1 != y2
      end)

    calc_area(point1, point2)
  end

  def part2(args) do
    points = condition_input(args)
    indexed_points = Enum.with_index(points)

    polygon = make_polygon(points, %Build{})

    filtered_rectangles =
      indexed_points
      |> generate_all_rectangles()
      |> bounds_filter(polygon, points)

    # biggest_rect =
    #   filtered_rectangles
    #   |> Enum.sort_by(&calc_rect_area/1, :desc)
    #   |> List.first()

    # write_points_to_svg(points, [biggest_rect])

    filtered_rectangles
    |> Enum.map(&calc_rect_area/1)
    |> Enum.max()
  end

  defp bounds_filter(rectangles, polygon, points) do
    Enum.reject(rectangles, fn rectangle ->
      Enum.any?(rectangle, fn line ->
        Enum.any?(polygon, fn poly_line ->
          Line.intersect?(line, poly_line)
        end) or
          Enum.any?(points, fn point ->
            point_in_rect_bounds?(point, rectangle)
          end)
      end)
    end)
  end

  @spec point_in_rect_bounds?(point :: Line.xy(), list(Line.t())) :: boolean()
  defp point_in_rect_bounds?(point, rectangle) do
    {x, y} = point
    # first point is top left, second is bottom right of rect
    [{x1, y1}, {x2, y2}] = rect_corner_points(rectangle)

    x1 < x and x < x2 and y1 < y and y < y2
  end

  @spec points_from_rect(rectangle :: list(Line.t())) :: list(Line.xy())
  defp points_from_rect(rectangle) do
    rectangle
    |> Enum.flat_map(fn %Line{point1: point1, point2: point2} ->
      [point1, point2]
    end)
    |> Enum.uniq()
  end

  @spec rect_corner_points(rectangle :: list(Line.t())) :: list(Line.xy())
  defp rect_corner_points(rectangle) do
    [{x1, y1} = point1 | _] =
      points =
      rectangle
      |> points_from_rect()
      |> Enum.sort_by(fn {x, y} -> :math.sqrt(x * x + y * y) end)

    point2 =
      Enum.find(points, fn {x2, y2} ->
        x1 != x2 and y1 != y2
      end)

    [point1, point2]
  end

  # given a list of indexed points, make lines such that they all form a polygon
  @spec make_polygon(points :: list(Line.xy()), build_struct :: Build.t()) :: list(Line.t()) | nil
  defp make_polygon(points, build_struct) do
    %Build{polygon: polygon, start: start, tip: tip} = build_struct

    cond do
      # done
      length(polygon) == length(points) and polygon_closed?(polygon) ->
        polygon

      # went down a bad fork
      length(polygon) != length(points) and polygon_closed?(polygon) ->
        nil

      # begin building
      polygon == [] ->
        start_point = find_start_point(points)
        [next_point | _] = get_neighbors(start_point, points)
        line = Line.to_line(start_point, next_point)
        make_polygon(points, %Build{polygon: [line], start: start_point, tip: next_point})

      # continue building
      true ->
        tip
        |> get_neighbors(points)
        |> Enum.reject(fn point -> point_in_polygon?(point, polygon) and point != start end)
        |> Enum.map(fn next_point ->
          line = Line.to_line(tip, next_point)

          make_polygon(points, %Build{build_struct | polygon: [line | polygon], tip: next_point})
        end)
        |> Enum.reject(&is_nil/1)
        |> List.first()
    end
  end

  @spec point_in_polygon?(xy :: Line.xy(), polygon :: list(Line.t())) :: boolean()
  defp point_in_polygon?(xy, polygon) do
    Enum.any?(polygon, fn %Line{point1: point1, point2: point2} ->
      xy == point1 or xy == point2
    end)
  end

  @spec polygon_closed?(polygon :: list(Line.t())) :: boolean()
  defp polygon_closed?(polygon) when polygon == [], do: false

  defp polygon_closed?(polygon) do
    Enum.all?(polygon, fn %Line{point1: point1, point2: point2} = line ->
      polygon_to_check = polygon -- [line]

      point_in_polygon?(point1, polygon_to_check) and
        point_in_polygon?(point2, polygon_to_check)
    end)
  end

  # first point with only 2 neighbors
  @spec find_start_point(points :: list(Line.xy())) :: Line.xy()
  defp find_start_point(points) do
    Enum.find(points, fn xy ->
      get_neighbors(xy, points) |> length() |> Kernel.==(2)
    end)
  end

  @spec get_neighbors(xy :: Line.xy(), points :: list(Line.xy())) :: list(Line.xy())
  defp get_neighbors(xy, points) do
    {x1, y1} = xy

    neighbors_on_x =
      points
      |> Enum.filter(fn {x, _y} -> x == x1 end)
      |> Enum.sort_by(fn {x, _y} -> x end)
      |> then(fn sorted_points ->
        index = Enum.find_index(sorted_points, fn point -> point == xy end)

        left = if index - 1 < 0, do: nil, else: Enum.at(sorted_points, index - 1)
        right = Enum.at(sorted_points, index + 1)

        ([left] ++ [right])
        |> Enum.reject(&is_nil/1)
      end)

    neighbors_on_y =
      points
      |> Enum.filter(fn {_x, y} -> y == y1 end)
      |> Enum.sort_by(fn {_x, y} -> y end)
      |> then(fn sorted_points ->
        index = Enum.find_index(sorted_points, fn point -> point == xy end)

        top = if index - 1 < 0, do: nil, else: Enum.at(sorted_points, index - 1)
        bottom = Enum.at(sorted_points, index + 1)

        ([top] ++ [bottom])
        |> Enum.reject(&is_nil/1)
      end)

    neighbors_on_x ++ neighbors_on_y
  end

  defp write_points_to_svg(points, rectangles) do
    polygon_str =
      points
      # |> Enum.map(fn {x, y} -> {Integer.floor_div(x, 100), Integer.floor_div(y, 100)} end)
      |> Enum.map(fn {x, y} -> "#{x},#{y}" end)
      |> Enum.join(" ")

    rectangles_str =
      rectangles
      |> Enum.map(fn rectangle ->
        {x, y, width, height} =
          rectangle
          |> points_from_rect()
          |> then(fn points ->
            [{x1, y1} | _] = points

            {x2, y2} =
              Enum.find(points, fn {x2, y2} ->
                x1 != x2 and y1 != y2
              end)

            x = min(x1, x2)
            y = min(y1, y2)
            width = abs(x2 - x1)
            height = abs(y2 - y1)

            {x, y, width, height}
          end)

        """
        <rect x="#{x}" y="#{y}" 
              width="#{width}" height="#{height}" 
              fill="none" 
              stroke="red" 
              stroke-width="100"/>
        """
      end)
      |> Enum.join("\n")

    svg_str = """
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100000 100000">
      <polygon points="#{polygon_str}" 
                fill="none" 
                stroke="black" 
                stroke-width="100"/>
      #{rectangles_str}
    </svg>
    """

    File.write("output.svg", svg_str)
  end
end
