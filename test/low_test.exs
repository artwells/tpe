defmodule LowTest do
  use ExUnit.Case
  doctest Low

  test "greets the world" do
    assert Low.hello() == :world
  end
end
