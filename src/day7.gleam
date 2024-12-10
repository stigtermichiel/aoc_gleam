import aoc_gleam
import gleam/io

pub fn main() {
  let path = "day1"
  let a = aoc_gleam.read_string_rows(path, ":")

  io.debug(a)
}
