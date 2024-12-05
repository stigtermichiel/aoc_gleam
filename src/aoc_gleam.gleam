import gleam/int
import gleam/string
import simplifile
import gleam/list


pub type StringRows = List(List(String))
pub type IntRows = List(List(Int))

pub fn read_string_rows(file) -> StringRows{
  let content = read_string(file)
  string.split(content, "\n")
  |> list.map(fn(a) { string.split(a, " ") |> list.filter(fn(s) { !string.is_empty(s) }) })
  |> list.filter(fn(a) { !list.is_empty(a) })
}

pub fn read_string(file) ->  String {
  let path = "./input_files/" <> file
  let assert Ok(content) = simplifile.read(path)
  content
}



pub fn to_int(l: List(List(String))) -> IntRows {
  list.map(l, fn(a) { list.filter_map(a, fn(b) { int.parse(b)})})
}
