defmodule Tpe.RulePart.CreateTest do
  use ExUnit.Case, async: false
  alias Tpe.RulePart.Create
  

  doctest Tpe.RulePart.Create, import: true

  setup do
   Tpe.TestTools.sandbox_connection()
    :ok
  end

  test "creates a new rule part with the given attributes" do
    {:ok, rule} = Tpe.Rule.Create.create_rule(%{name: "Rule 1", description: "a new rule"})
    attrs = %{rule_id: rule.id, block: "tester block", verb: "verb", arguments: %{}}
    {:ok, rule_part} = Create.create_rule_part(attrs)

    part = Map.from_struct(rule_part)
    assert "tester block" == part.block
    assert rule.id == part.rule_id
  end
end
