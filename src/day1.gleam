import aoc_gleam
import gleam/int
import gleam/io
import gleam/list

pub fn main() {
  let path = "day1"
  let a = aoc_gleam.to_int(aoc_gleam.read_string_rows(path, " "))

  io.println("day 1a")
  let left: List(Int) =
    list.filter_map(a, fn(ab) { list.first(ab) }) |> list.sort(int.compare)
  let right: List(Int) =
    list.filter_map(a, fn(ab) { list.last(ab) }) |> list.sort(int.compare)
  let total_dis =
    list.map2(left, right, fn(ll, rl) { int.absolute_value(ll - rl) })
    |> list.fold(0, fn(acc, distance) { acc + distance })
  io.println(int.to_string(total_dis))

  io.println("day 1b")

  let similarity_score =
    list.map(left, fn(num) {
      let number_of_same_distances =
        list.count(right, fn(right_num) { right_num == num })
      num * number_of_same_distances
    })
    |> list.fold(0, fn(acc, distance) { acc + distance })

  io.println(int.to_string(similarity_score))
}

pub fn distance(tup: #(Int, Int)) -> Int {
  int.absolute_value(tup.0 - tup.1)
}
