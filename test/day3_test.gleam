// in test/vars_test.gleam
import day3
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn day3a_test() {
  day3.day3a("day3_test")
  |> should.equal(161)
}

pub fn day3b_test() {
  day3.day3a("day3b_test")
  |> should.equal(48)
}
