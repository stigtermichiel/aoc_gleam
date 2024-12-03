import aoc_gleam
import gleam/io
import gleam/int
import gleam/list


pub fn main() {
  let path = "day2"

  io.debug(day2a(path))
  io.debug(day2b(path))
}


fn safe(row: List(Int)) ->  Bool {
  let all_increase = fn(a: #(Int, Int)) {a.1 - a.0 > 0}
  let all_decrease = fn(a: #(Int, Int)) {a.1 - a.0 < 0}
  let not_too_big_or_too_small = fn(a: #(Int, Int)) {
    let diff = int.absolute_value(a.1 - a.0)
    diff > 0 && diff <= 3
  }

  row |> list.window_by_2 |> list.all(fn(a) {
    let stair = all_increase(a) || all_decrease(a)
    stair && not_too_big_or_too_small(a)
  })
}

pub fn day2a(path) -> Int {
  let reports =  aoc_gleam.to_int(aoc_gleam.read_string(path))
  reports
  |> list.count(safe)
}


pub fn day2b(path) -> Int {
  aoc_gleam.to_int(aoc_gleam.read_string(path))
  |> list.map(fn(a) {
    let number_of_levels = list.length(a)
    list.combinations(a, number_of_levels - 1) })
  |> list.count(fn(li) {
    list.any(li, fn(combination) {
      safe(combination)
    })})
}




