import aoc_gleam
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import grid

pub fn main() {
  let path = "day4"
  io.debug(day4a(path))
  io.debug(day4b(path))
}

pub fn traverse_all_directions(
  p: grid.Point,
  grid: List(#(grid.Point, String)),
) -> List(List(String)) {
  list.map(
    [
      grid.north(p, 3),
      grid.south(p, 3),
      grid.west(p, 3),
      grid.east(p, 3),
      grid.ne(p, 3),
      grid.nw(p, 3),
      grid.se(p, 3),
      grid.sw(p, 3),
    ],
    fn(dir) {
      list.map(dir, fn(yc) { result.unwrap(list.key_find(grid, yc), "") })
    },
  )
}

pub fn traverse_diagonal(
  p: grid.Point,
  grid: List(#(grid.Point, String)),
) -> List(List(String)) {
  list.map(
    [
      list.flatten([grid.ne(p, 1), grid.sw(p, 1)]),
      list.flatten([grid.nw(p, 1), grid.se(p, 1)]),
    ],
    fn(dir) {
      list.map(dir, fn(yc) { result.unwrap(list.key_find(grid, yc), "") })
    },
  )
}

pub fn day4a(path) -> Int {
  let input = aoc_gleam.read_string_rows(path, "")

  let grid: List(#(grid.Point, String)) = grid.to_grid(input)

  list.filter(grid, fn(p) { p.1 == "X" })
  |> list.map(fn(xpoint) { traverse_all_directions(xpoint.0, grid) })
  |> list.flatten
  |> list.count(fn(str) { string.join(str, "") == "MAS" })
}

pub fn day4b(path) -> Int {
  let input = aoc_gleam.read_string_rows(path, "")

  let grid: List(#(grid.Point, String)) = grid.to_grid(input)

  list.filter(grid, fn(p) { p.1 == "A" })
  |> list.map(fn(xpoint) { traverse_diagonal(xpoint.0, grid) })
  |> list.count(fn(pairs) {
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
}
