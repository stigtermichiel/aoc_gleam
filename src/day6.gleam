import aoc_gleam
import gleam/dict
import gleam/io
import gleam/list
import gleam/result
import gleam/set
import gleam/string
import grid.{type Direction, type Point, East, North, Point, South, West}

pub fn main() {
  let path = "day6"
  let input = aoc_gleam.read_string_rows(path, "")
  let grid: List(#(Point, String)) = grid.to_grid(input)
  let a = dict.from_list(grid)

  io.debug(day6a(a))
  io.debug(day6b(a))
}

pub fn day6a(grid: dict.Dict(Point, String)) -> Int {
  let starting_dir = grid.North
  let assert Ok(starting_point) =
    list.find(dict.to_list(grid), fn(point_tup) { point_tup.1 == "^" })

  let locations_visited =
    traverse_loop(grid, starting_point.0, starting_dir, set.new()).1
    |> set.map(fn(p) { p.0 })
    |> set.size()

  locations_visited + 1
}

pub fn day6b(grid: dict.Dict(Point, String)) -> Int {
  let starting_dir = grid.North
  let assert Ok(starting_point) =
    list.find(dict.to_list(grid), fn(point_tup) { point_tup.1 == "^" })

  traverse_loop(grid, starting_point.0, starting_dir, set.new()).1
  |> set.map(fn(potential_obstacle_location: #(Point, Direction)) {
    let next_point: Point =
      look_ahead(potential_obstacle_location.1, potential_obstacle_location.0)
    let grid_with_new_obst = dict.insert(grid, next_point, "O")
    traverse_loop(grid_with_new_obst, starting_point.0, North, set.new())
  })
  |> set.filter(fn(sa) { sa.2 })
  |> set.map(fn(x) { obstacle_location(x.0) })
  |> set.size()
}

fn obstacle_location(g: dict.Dict(Point, String)) -> Point {
  let assert Ok(a) =
    dict.filter(g, fn(_k, v) { v == "O" })
    |> dict.keys
    |> list.first()

  a
}

fn turn(dir: Direction) -> Direction {
  case dir {
    East -> South
    North -> East
    South -> West
    West -> grid.North
  }
}

fn look_ahead(dir: Direction, pos: Point) -> Point {
  case dir {
    East -> result.unwrap(list.first(grid.east(pos, 1)), Point(-10, -10))
    North -> result.unwrap(list.first(grid.north(pos, 1)), Point(-10, -10))
    South -> result.unwrap(list.first(grid.south(pos, 1)), Point(-10, -10))
    West -> result.unwrap(list.first(grid.west(pos, 1)), Point(-10, -10))
  }
}

pub fn traverse_loop(
  grid: dict.Dict(Point, String),
  pos: Point,
  dir: grid.Direction,
  traveled: set.Set(#(Point, Direction)),
) -> #(dict.Dict(Point, String), set.Set(#(Point, Direction)), Bool) {
  let next_point: Point = look_ahead(dir, pos)
  let value: String = result.unwrap(dict.get(grid, next_point), "")

  case value {
    "." ->
      traverse_loop(
        dict.insert(grid, pos, "x"),
        next_point,
        dir,
        set.insert(traveled, #(pos, dir)),
      )
    "x" ->
      case set.contains(traveled, #(pos, dir)) {
        False ->
          traverse_loop(
            dict.insert(grid, pos, "x"),
            next_point,
            dir,
            set.insert(traveled, #(pos, dir)),
          )
        True -> #(grid, traveled, True)
      }
    "#" | "O" -> traverse_loop(grid, pos, turn(dir), traveled)
    "" -> #(grid, traveled, False)
    _ -> #(grid, traveled, False)
  }
}

pub fn to_string(grid: dict.Dict(Point, String)) -> String {
  let x = list.range(0, 9)
  let y = list.range(0, 9)

  list.fold(y, "", fn(acc, riy) {
    let s: List(String) =
      list.map(x, fn(rix) { result.unwrap(dict.get(grid, Point(rix, riy)), "") })
    acc <> string.join(s, " ") <> "\n"
  })
}
