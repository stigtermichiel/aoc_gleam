import gleam/int
import gleam/list
import gleam/string
import simplifile

pub type StringRows =
  List(List(String))

pub type IntRows =
  List(List(Int))

pub fn read_string_rows(file, split_string) -> StringRows {
  let content = read_string(file)
  string.split(content, "\n")
  |> list.map(fn(a) {
    string.split(a, split_string) |> list.filter(fn(s) { !string.is_empty(s) })
  })
  |> list.filter(fn(a) { !list.is_empty(a) })
}

pub fn read_string(file) -> String {
  let path = "./input_files/" <> file
  let assert Ok(content) = simplifile.read(path)
  content
}

pub fn to_int(l: List(List(String))) -> IntRows {
  list.map(l, fn(a) { list.filter_map(a, fn(b) { int.parse(b) }) })
}
