// in test/vars_test.gleam
import day4
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn day4a_test() {
  day4.day4a("day4_test")
  |> should.equal(18)
}

pub fn day4b_test() {
  day4.day4b("day4_test")
  |> should.equal(9)
}
