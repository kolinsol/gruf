defmodule GrufTest do
  use ExUnit.Case
  doctest Gruf

  test "greets the world" do
    assert Gruf.hello() == :world
  end
end
