import gleam/int
import gleam/string
import simplifile
import gleam/list


pub fn read_string_to_tuple(file) {
  let path = "./input_files/" <> file
  let assert Ok(content) = simplifile.read(path)
  string.split(content, "\n")
  |> list.filter_map(fn(a) { string.split_once(a, "   ") })
}

pub fn string_tuple_to_int(str_tup: List(#(String, String))) -> List(#(Int, Int)) {
  list.filter_map(str_tup, fn(st_tup) {
    let left_parse_result =  int.parse(st_tup.0)
    let right_parse_result =  int.parse(st_tup.1)

    case left_parse_result {
      Ok(i) -> {
        case right_parse_result {
          Ok(a) -> Ok(#(i, a))
          Error(x) -> Error(x)
        }
      }
      Error(x) -> Error(x)
    }
  })
}
