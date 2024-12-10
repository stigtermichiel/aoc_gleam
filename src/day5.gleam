import aoc_gleam
import gleam/int
import gleam/io
import gleam/list
import gleam/order.{type Order}
import gleam/result
import gleam/string

pub fn main() {
  let path = "day5"

  let input = aoc_gleam.read_string(path)
  let rules = get_rules(input)

  let updates = get_updates(input)
  io.debug(day5a(rules, updates))
  io.debug(day5b(rules, updates))
}

pub fn day5a(rules, updates) -> Int {
  list.map(updates, all_possible_rules)
  |> list.filter(fn(update_tuple) {
    !list.any(update_tuple.1, fn(a) { list.any(rules, fn(rule) { rule == a }) })
  })
  |> list.map(fn(tup) { tup.0 })
  |> list.map(fn(li) { list.map(li, fn(s) { result.unwrap(int.parse(s), 0) }) })
  |> list.map(middle)
  |> int.sum
}

pub fn day5b(rules, updates) -> Int {
  let a: List(#(List(String), List(Rule))) =
    list.map(updates, all_possible_rules)
    |> list.filter(fn(update_tuple) {
      list.any(update_tuple.1, fn(a) { list.any(rules, fn(rule) { rule == a }) })
    })

  list.map(a, fn(update_tuple) {
    let list_to_update: List(String) = update_tuple.0
    let c =
      list.sort(list_to_update, fn(a1, a2) -> Order {
        case
          rule_exist_in_rule_book(Rule(a1, a2), rules),
          rule_exist_in_rule_book(Rule(a2, a1), rules)
        {
          True, False -> order.Lt
          False, True -> order.Gt
          _, _ -> order.Eq
        }
      })
    c
  })
  |> list.map(fn(li) { list.map(li, fn(s) { result.unwrap(int.parse(s), 0) }) })
  |> list.map(middle)
  |> int.sum
}

pub type Rule {
  Rule(first: String, second: String)
}

pub fn get_rules(input: String) {
  let split_input = string.split(input, "\n\n")

  list.first(split_input)
  |> result.unwrap("")
  |> string.split("\n")
  |> list.map(fn(entry) {
    let entries = string.split(entry, "|")
    Rule(
      result.unwrap(list.first(entries), ""),
      result.unwrap(list.last(entries), ""),
    )
  })
}

pub fn get_updates(input: String) -> List(List(String)) {
  let a = string.split(input, "\n\n")

  list.last(a)
  |> result.unwrap("")
  |> string.split("\n")
  |> list.map(fn(entry) { string.split(entry, ",") })
}

fn middle(l: List(Int)) -> Int {
  list.drop(l, list.length(l) / 2)
  |> list.first
  |> result.unwrap(0)
}

fn all_possible_rules(update: List(String)) -> #(List(String), List(Rule)) {
  let all_rules_reversed =
    list.reverse(update)
    |> list.combination_pairs()
    |> list.map(fn(pair) { Rule(pair.0, pair.1) })
  #(update, all_rules_reversed)
}

pub fn rule_exist_in_rule_book(rule: Rule, rules: List(Rule)) -> Bool {
  list.any(rules, fn(ru) { ru == rule })
}
