defmodule TpeTest do
  use ExUnit.Case
  doctest Tpe

  test "greets the world" do
    assert Tpe.hello() == :world
  end
end
