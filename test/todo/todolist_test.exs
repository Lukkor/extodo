defmodule Todo.TodolistTest do
  use ExUnit.Case

  test "return entries for a date" do
    todolist =
      Todo.Todolist.new
      |> Todo.Todolist.add_entry(%{date: {2016, 05, 11}, title: "drink a beer!"})

    assert Todo.Todolist.entries(todolist, {2016, 05, 11}) == [%{date: {2016, 05, 11}, id: 1, title: "drink a beer!"}]
    assert Todo.Todolist.count(todolist) == 1
  end

  test "modify entry by id" do
    todolist =
      Todo.Todolist.new
      |> Todo.Todolist.add_entry(%{date: {2016, 05, 11}, title: "drink a beer!"})
      |> Todo.Todolist.update_entry(1, &Map.put(&1, :date, {2016, 05, 13}))

    assert Todo.Todolist.entries(todolist, {2016, 05, 11}) == []
    assert Todo.Todolist.entries(todolist, {2016, 05, 13}) == [%{date: {2016, 05, 13}, id: 1, title: "drink a beer!"}]
    assert Todo.Todolist.count(todolist) == 1
  end

  test "when entry does not exist, return unchanged list" do
    todolist =
      Todo.Todolist.new
      |> Todo.Todolist.add_entry(%{date: {2016, 05, 11}, title: "drink a beer!"})
      |> Todo.Todolist.update_entry(9, &Map.put(&1, :date, {2016, 05, 13}))

    assert Todo.Todolist.entries(todolist, {2016, 05, 11}) == [%{date: {2016, 05, 11}, id: 1, title: "drink a beer!"}]
    assert Todo.Todolist.count(todolist) == 1
  end

  test "delete entry by id" do
    todolist =
      Todo.Todolist.new
      |> Todo.Todolist.add_entry(%{date: {2016, 05, 11}, title: "drink a beer!"})
      |> Todo.Todolist.add_entry(%{date: {2016, 05, 11}, title: "eat chips!"})
      |> Todo.Todolist.delete_entry(2)

    assert Todo.Todolist.entries(todolist, {2016, 05, 11}) == [%{date: {2016, 05, 11}, id: 1, title: "drink a beer!"}]
    assert Todo.Todolist.count(todolist) == 1
  end

  test "when entry does not exist, return unchanged list" do
    todolist =
      Todo.Todolist.new
      |> Todo.Todolist.add_entry(%{date: {2016, 05, 11}, title: "drink a beer!"})
      |> Todo.Todolist.delete_entry(9)

    assert Todo.Todolist.entries(todolist, {2016, 05, 11}) == [%{date: {2016, 05, 11}, id: 1, title: "drink a beer!"}]
    assert Todo.Todolist.count(todolist) == 1
  end

  test "create a todolist with entries" do
    entries = [
      %{date: {2016, 05, 11}, title: "drink a beer!"},
      %{date: {2016, 05, 11}, title: "eat chips!"}
    ]
    todolist = Todo.Todolist.new(entries)

    assert Todo.Todolist.entries(todolist, {2016, 05, 11}) == [%{date: {2016, 05, 11}, id: 2, title: "eat chips!"}, %{date: {2016, 05, 11}, id: 1, title: "drink a beer!"}]
    assert Todo.Todolist.count(todolist) == 2
  end

end
