import aoc_gleam
import gleam/int
import gleam/io
import gleam/list

pub fn main() {
  let path = "day2"

  io.debug(day2a(path))
  io.debug(day2b(path))
}

fn safe(row: List(Int)) -> Bool {
  let sorted_row = list.sort(row, int.compare)
  let all_up_or_all_down = sorted_row == row || list.reverse(sorted_row) == row

  let not_too_big_or_too_small = fn(a: #(Int, Int)) {
    let diff = int.absolute_value(a.1 - a.0)
    diff > 0 && diff <= 3
  }

  row
  |> list.window_by_2
  |> list.all(fn(a) { all_up_or_all_down && not_too_big_or_too_small(a) })
}

pub fn day2a(path) -> Int {
  let reports = aoc_gleam.to_int(aoc_gleam.read_string_rows(path))
  reports
  |> list.count(safe)
}

pub fn day2b(path) -> Int {
  aoc_gleam.to_int(aoc_gleam.read_string_rows(path))
  |> list.map(fn(a) {
    let number_of_levels = list.length(a)
    list.combinations(a, number_of_levels - 1)
  })
  |> list.count(fn(li) { list.any(li, fn(combination) { safe(combination) }) })
}
