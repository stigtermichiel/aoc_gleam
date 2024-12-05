import aoc_gleam
import gleam/int
import gleam/io
import gleam/list
import gleam/option
import gleam/regexp

pub fn main() {
  let path = "day3"

  io.debug(day3a(path))
  io.debug(day3b(path))
}

pub fn day3a(path) -> Int {
  let input = aoc_gleam.read_string(path)

  let assert Ok(re) = regexp.from_string("mul\\((\\d+),(\\d+)\\)")
  let a: List(regexp.Match) = regexp.scan(with: re, content: input)
  let b =
    list.map(a, fn(a: regexp.Match) { a.submatches })
    |> list.map(fn(matches) {
      let numbers: List(String) = option.values(matches)
      list.filter_map(numbers, fn(num) { int.parse(num) })
      |> list.fold(1, fn(acc, num) { acc * num })
    })

  list.fold(b, 0, fn(acc, num) { acc + num })
}

pub type State {
  State(number: Int, state: Bool)
}

pub fn day3b(path) -> Int {
  let input = aoc_gleam.read_string(path)

  let assert Ok(re) =
    regexp.from_string("mul\\((\\d+),(\\d+)\\)|do\\(\\)|don't\\(\\)")
  let a: List(regexp.Match) = regexp.scan(with: re, content: input)

  let b: State =
    list.fold(a, State(0, True), fn(acc, match: regexp.Match) {
      case match.content {
        "don't()" -> State(..acc, state: False)
        "do()" -> State(..acc, state: True)
        _ -> {
          case
            list.filter_map(option.values(match.submatches), fn(num) {
              int.parse(num)
            })
          {
            [num1, num2, ..] if acc.state ->
              State(number: acc.number + { num1 * num2 }, state: acc.state)
            [_, _, ..] if !acc.state -> State(..acc, state: acc.state)
            _ -> acc
          }
        }
      }
    })

  b.number
}
