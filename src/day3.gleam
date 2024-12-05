import aoc_gleam
import gleam/int
import gleam/io
import gleam/list
import gleam/option
import gleam/regexp
import gleam/result

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
  let matches: List(regexp.Match) = regexp.scan(with: re, content: input)

  let state: State =
    list.fold(matches, State(0, True), fn(acc, match: regexp.Match) {
      case match.content {
        "don't()" -> State(..acc, state: False)
        "do()" -> State(..acc, state: True)
        _ -> {
          case match.submatches {
            [option.Some(num1), option.Some(num2), ..] if acc.state ->
              State(
                number: acc.number
                  + {
                  result.unwrap(int.parse(num1), 0)
                  * result.unwrap(int.parse(num2), 0)
                },
                state: acc.state,
              )
            [_, _, ..] if !acc.state -> State(..acc, state: acc.state)
            _ -> acc
          }
        }
      }
    })

  state.number
}
