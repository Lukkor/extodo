defmodule MultiDictTest do
  use ExUnit.Case

  test "return values for a key" do
    multi_dict =
      MultiDict.new
      |> MultiDict.add(:key, :value)

    assert MultiDict.get(multi_dict, :key) == [:value]
  end
end
