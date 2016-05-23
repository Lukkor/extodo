defmodule Todo.ListTest do
  use ExUnit.Case

  test "return entries for a date" do
    todolist =
      Todo.List.new
      |> Todo.List.add_entry(%{date: {2016, 05, 11}, title: "drink a beer!"})

    assert Todo.List.entries(todolist, {2016, 05, 11}) == [%{date: {2016, 05, 11}, id: 1, title: "drink a beer!"}]
    assert Todo.List.count(todolist) == 1
  end

  test "modify entry by id" do
    todolist =
      Todo.List.new
      |> Todo.List.add_entry(%{date: {2016, 05, 11}, title: "drink a beer!"})
      |> Todo.List.update_entry(1, &Map.put(&1, :date, {2016, 05, 13}))

    assert Todo.List.entries(todolist, {2016, 05, 11}) == []
    assert Todo.List.entries(todolist, {2016, 05, 13}) == [%{date: {2016, 05, 13}, id: 1, title: "drink a beer!"}]
    assert Todo.List.count(todolist) == 1
  end

  test "when entry does not exist, return unchanged list" do
    todolist =
      Todo.List.new
      |> Todo.List.add_entry(%{date: {2016, 05, 11}, title: "drink a beer!"})
      |> Todo.List.update_entry(9, &Map.put(&1, :date, {2016, 05, 13}))

    assert Todo.List.entries(todolist, {2016, 05, 11}) == [%{date: {2016, 05, 11}, id: 1, title: "drink a beer!"}]
    assert Todo.List.count(todolist) == 1
  end

  test "delete entry by id" do
    todolist =
      Todo.List.new
      |> Todo.List.add_entry(%{date: {2016, 05, 11}, title: "drink a beer!"})
      |> Todo.List.add_entry(%{date: {2016, 05, 11}, title: "eat chips!"})
      |> Todo.List.delete_entry(2)

    assert Todo.List.entries(todolist, {2016, 05, 11}) == [%{date: {2016, 05, 11}, id: 1, title: "drink a beer!"}]
    assert Todo.List.count(todolist) == 1
  end

  test "when entry does not exist, return unchanged list" do
    todolist =
      Todo.List.new
      |> Todo.List.add_entry(%{date: {2016, 05, 11}, title: "drink a beer!"})
      |> Todo.List.delete_entry(9)

    assert Todo.List.entries(todolist, {2016, 05, 11}) == [%{date: {2016, 05, 11}, id: 1, title: "drink a beer!"}]
    assert Todo.List.count(todolist) == 1
  end

  test "create a todolist with entries" do
    entries = [
      %{date: {2016, 05, 11}, title: "drink a beer!"},
      %{date: {2016, 05, 11}, title: "eat chips!"}
    ]
    todolist = Todo.List.new(entries)

    assert Todo.List.entries(todolist, {2016, 05, 11}) == [%{date: {2016, 05, 11}, id: 2, title: "eat chips!"}, %{date: {2016, 05, 11}, id: 1, title: "drink a beer!"}]
    assert Todo.List.count(todolist) == 2
  end

end
