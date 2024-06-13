defmodule Tpe.RulePart.DeleteTest do
  use ExUnit.Case, async: true
  alias Tpe.RulePart.Delete
  alias Tpe.RulePart.Create
  alias Tpe.TestTools

  doctest Tpe.RulePart.Delete, import: true

  setup do
    TestTools.sandbox_connection()
    :ok
  end

  test "delete_rule_part/1 deletes a rule part with the given ID from the database" do
    {:ok, rule} = Tpe.Rule.Create.create_rule(%{name: "Rule 1", description: "a new rule"})

    attrs = %{rule_id: rule.id, block: "tester block", verb: "verb", arguments: %{}}
    {:ok, rule_part} = Create.create_rule_part(attrs)

    # Action
    {:ok, _} = Delete.delete_rule_part(rule_part.id)

    # Assertion
    assert nil == Tpe.Repo.get(Tpe.RulePart, rule_part.id)
  end

  test "delete_rule_parts_by_rule_id/1 deletes all rule parts associated with a given rule ID from the database" do
    # Setup
    {:ok, rule} = Tpe.Rule.Create.create_rule(%{name: "Rule 1", description: "a new rule"})

    attrs = %{rule_id: rule.id, block: "tester block", verb: "verb", arguments: %{}}
    {:ok, rule_part1} = Create.create_rule_part(attrs)
    attrs = %{rule_id: rule.id, block: "tester block", verb: "verb", arguments: %{}}
    {:ok, rule_part2} = Create.create_rule_part(attrs)

    # Action
    {2, nil} = Delete.delete_rule_parts_by_rule_id(rule.id)

    # Assertion
    assert nil == Tpe.Repo.get(Tpe.RulePart, rule_part1.id)
    assert nil == Tpe.Repo.get(Tpe.RulePart, rule_part2.id)
  end
end
