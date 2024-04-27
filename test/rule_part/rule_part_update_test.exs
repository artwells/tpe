defmodule Tpe.RulePart.UpdateTest do
  use ExUnit.Case, async: true
  alias Tpe.RulePart.Update
  alias Tpe.RulePart.Create
  alias Tpe.TestTools

  doctest Tpe.RulePart.Update


  setup do
    TestTools.sandbox_connection()
    :ok
  end


  test "update_rule_part/2 updates a rule part with the given ID and attributes" do
    # Setup
    attrs = %{name: "New Rule"}
    {:ok, rule} = Tpe.Rule.Create.create_rule(%{name: "Rule 1", description: "a new rule"})

    attrs = %{rule_id: rule.id, block: "tester block", verb: "verb", arguments: %{}}
    {:ok, rule_part} = Create.create_rule_part(attrs)
    # Action
    updated_attrs = %{block: "updated block", verb: "updated verb"}
    {:ok, updated_rule_part} = Update.update_rule_part(rule_part.id, updated_attrs)

    # Assertion
    assert updated_rule_part.block == "updated block"
    assert updated_rule_part.verb == "updated verb"
  end

  test "update_rule_part/2 returns an error if the rule part is not found" do
    # Action
    error = Update.update_rule_part(98, %{block: "updated block", verb: "updated verb"})

    # Assertion
    assert {:error, :rule_part_not_found} == error
  end
end
