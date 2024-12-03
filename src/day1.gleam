import aoc_gleam
import gleam/io
import gleam/int
import gleam/list


pub fn main() {
   let path = "day1"

   let b: List(#(String, String)) = aoc_gleam.read_string_to_tuple(path)
   let s = aoc_gleam.string_tuple_to_int(b)
   let a = sort_tuple(s)

   let total_distance = list.map(a, fn(tup) {distance(tup)}) |> list.fold(0, fn(acc, distance) { acc + distance })


   io.debug(total_distance)
}

pub fn sort_tuple(a: List(#(Int, Int))) -> List(#(Int, Int)) {
  let list_a = list.map(a, fn(x) { x.0 }) |> list.sort(int.compare)
  let list_b = list.map(a, fn(x) { x.1 }) |> list.sort(int.compare)

  list.map2(list_a, list_b, fn(a, b) { #(a, b) })
}

pub fn distance(tup: #(Int, Int)) -> Int {
  int.absolute_value(tup.0 - tup.1)
}


