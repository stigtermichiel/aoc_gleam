import gleam/list

pub type Point {
  Point(x: Int, y: Int)
}

pub type Direction {
  North
  South
  West
  East
}

pub fn to_grid(l: List(List(String))) -> List(#(Point, String)) {
  list.flatten(
    list.index_map(l, fn(chars, y) {
      list.index_map(chars, fn(char, x) { #(Point(x, y), char) })
    }),
  )
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
