import aoc_gleam
import gleam/io
import gleam/list
import gleam/result
import gleam/string

pub fn main() {
  let path = "day4"
  io.debug(day4a(path))
  io.debug(day4b(path))
}

pub type Point {
  Point(x: Int, y: Int)
}

pub fn west(p: Point, how_far: Int) {
  list.map(list.range(p.x - 1, p.x - how_far), fn(co) { Point(co, p.y) })
}

pub fn east(p: Point, how_far: Int) {
  list.map(list.range(p.x + 1, p.x + how_far), fn(co) { Point(co, p.y) })
}

pub fn north(p: Point, how_far: Int) {
  list.map(list.range(p.y - 1, p.y - how_far), fn(co) { Point(p.x, co) })
}

pub fn south(p: Point, how_far: Int) {
  list.map(list.range(p.y + 1, p.y + how_far), fn(co) { Point(p.x, co) })
}

pub fn se(p: Point, how_far: Int) {
  list.take(
    [Point(p.x + 1, p.y + 1), Point(p.x + 2, p.y + 2), Point(p.x + 3, p.y + 3)],
    how_far,
  )
}

pub fn ne(p: Point, how_far: Int) {
  list.take(
    [Point(p.x + 1, p.y - 1), Point(p.x + 2, p.y - 2), Point(p.x + 3, p.y - 3)],
    how_far,
  )
}

pub fn nw(p: Point, how_far: Int) {
  list.take(
    [Point(p.x - 1, p.y - 1), Point(p.x - 2, p.y - 2), Point(p.x - 3, p.y - 3)],
    how_far,
  )
}

pub fn sw(p: Point, how_far: Int) {
  list.take(
    [Point(p.x - 1, p.y + 1), Point(p.x - 2, p.y + 2), Point(p.x - 3, p.y + 3)],
    how_far,
  )
}

pub fn traverse_all_directions(
  p: Point,
  grid: List(#(Point, String)),
) -> List(List(String)) {
  list.map(
    [
      north(p, 3),
      south(p, 3),
      west(p, 3),
      east(p, 3),
      ne(p, 3),
      nw(p, 3),
      se(p, 3),
      sw(p, 3),
    ],
    fn(dir) {
      list.map(dir, fn(yc) { result.unwrap(list.key_find(grid, yc), "") })
    },
  )
}

pub fn traverse_diagonal(
  p: Point,
  grid: List(#(Point, String)),
) -> List(List(String)) {
  list.map(
    [list.flatten([ne(p, 1), sw(p, 1)]), list.flatten([nw(p, 1), se(p, 1)])],
    fn(dir) {
      list.map(dir, fn(yc) { result.unwrap(list.key_find(grid, yc), "") })
    },
  )
}

pub fn to_grid(l: List(List(String))) -> List(#(Point, String)) {
  list.flatten(
    list.index_map(l, fn(chars, y) {
      list.index_map(chars, fn(char, x) { #(Point(x, y), char) })
    }),
  )
}

pub fn day4a(path) -> Int {
  let input = aoc_gleam.read_string_rows(path, "")

  let grid: List(#(Point, String)) = to_grid(input)

  list.filter(grid, fn(p) { p.1 == "X" })
  |> list.map(fn(xpoint) { traverse_all_directions(xpoint.0, grid) })
  |> list.flatten
  |> list.filter(fn(str) { string.join(str, "") == "MAS" })
  |> list.length
}

pub fn day4b(path) -> Int {
  let input = aoc_gleam.read_string_rows(path, "")

  let grid: List(#(Point, String)) = to_grid(input)

  list.filter(grid, fn(p) { p.1 == "A" })
  |> list.map(fn(xpoint) { traverse_diagonal(xpoint.0, grid) })
  |> list.filter(fn(pairs) {
    case pairs {
      [a, b] ->
        case a, b {
          [char1, char2], [char3, char4] -> {
            let p1 = char1 <> char2
            let p2 = char3 <> char4
            { p1 == "MS" || p1 == "SM" } && { p2 == "MS" || p2 == "SM" }
          }
          _, _ -> False
        }
      _ -> False
    }
  })
  |> list.length
}
