// in test/vars_test.gleam
import day1
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

const input = [#(3, 4), #(4, 3), #(2, 5), #(1, 3), #(3, 9), #(3, 3)]

pub fn day1_test() {
  day1.sort_tuple(input)
  |> should.equal([#(1, 3), #(2, 3), #(3, 3), #(3, 4), #(3, 5), #(4, 9)])
}


