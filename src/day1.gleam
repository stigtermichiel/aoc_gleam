import aoc_gleam
import gleam/io
import gleam/int
import gleam/list


pub fn main() {
   let path = "day1"

  let parsed_list: List(#(String, String)) = aoc_gleam.read_string_to_tuple(path)
  let int_tuples = aoc_gleam.string_tuple_to_int(parsed_list)
  let sorted_tuples = sort_tuple(int_tuples)

  let total_distance = list.map(sorted_tuples, fn(tup) {distance(tup)}) |> list.fold(0, fn(acc, distance) { acc + distance })

  io.println("day 1a")
  io.println(int.to_string(total_distance))


  let left_list = list.map(int_tuples, fn(tup) {tup.0})
  let right_list = list.map(int_tuples, fn(tup) {tup.1})

  let b = list.map(left_list, fn(num) {
    let number_of_same_distances  = list.count(right_list, fn(right_num) { right_num == num })
    num * number_of_same_distances
  }) |> list.fold(0, fn(acc, distance) { acc + distance })

  io.println("day 1b")
  io.println(int.to_string(b))


}

pub fn sort_tuple(a: List(#(Int, Int))) -> List(#(Int, Int)) {
  let list_a = list.map(a, fn(x) { x.0 }) |> list.sort(int.compare)
  let list_b = list.map(a, fn(x) { x.1 }) |> list.sort(int.compare)

  list.map2(list_a, list_b, fn(a, b) { #(a, b) })
}

pub fn distance(tup: #(Int, Int)) -> Int {
  int.absolute_value(tup.0 - tup.1)
}


