defmodule Tpe.RulePart.CreateTest do
  use ExUnit.Case
  doctest Tpe.RulePart.Create, import: true
  alias Tpe.RulePart.Create

  setup do
      Tpe.TestTools.cleanup()
      :ok
  end

  describe "create_rule_part/1" do
    test "creates a new rule part with the given attributes" do
      attrs = %{rule_id: 8, block: "tester block", verb: "verb", arguments: %{}}
      {:ok, rule_part} = Create.create_rule_part(attrs)

      part = Map.from_struct(rule_part)
      assert "tester block" == part.block
      assert 8 == part.rule_id
    end
  end
end
