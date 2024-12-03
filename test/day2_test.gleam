// in test/vars_test.gleam
import day2
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn day2a_test() {
  day2.day2a("day2_test")
  |> should.equal(2)
}
