import gleam/int
import gleam/io
import gleam/result
import gleam/string
import simplifile
import gleam/list

pub fn main() {
  let path = "/tmp/bla"
  let file_res = simplifile.read(path)

  let _a =
    file_res
    |> result.map(fn(x) { string.split(x, "\n") })
    |> result.map(fn(y) { string.concat(y) })

  let assert Ok(x) = file_res

  io.print(x)
}



pub fn read_string_to_tuple(file) {
  let path = "./input_files/" <> file
  let assert Ok(content) = simplifile.read(path)
  string.split(content, "\n")
  |> list.filter_map(fn(a) { string.split_once(a, "   ") })
}

pub fn string_tuple_to_int(str_tup: List(#(String, String))) -> List(#(Int, Int)) {
    let a: List(Result(#(Int, Int), Nil)) = list.filter_map(str_tup, fn(st) {
      let a: Result(Int, Nil)  = int.base_parse(st.0, 10)
      let b: Result(Int, Nil) = int.base_parse(st.1, 10)
      result.map(a, fn(integer) {
        result.map(b, fn(integer1) { #(integer, integer1) })
      })
    })

  list.filter_map(a, fn(res) { res })
}
