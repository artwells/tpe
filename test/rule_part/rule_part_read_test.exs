defmodule Tpe.RulePart.ReadTest do
  use ExUnit.Case, async: true
  alias Tpe.RulePart.Create
  alias Tpe.RulePart.Read
  alias Tpe.TestTools

  doctest Tpe.RulePart.Read, import: true

  setup do
    TestTools.sandbox_connection()
    :ok
  end

  setup_all do
    TestTools.cleanup()
    :ok
  end

  test "get_rule_part/1 retrieves a rule part by its ID" do
    # Setup
    attrs = %{rule_id: 1, block: "tester block", verb: "verb", arguments: %{}}
    {:ok, rule_part} = Create.create_rule_part(attrs)

    # Action
    {:ok, retrieved_rule_part} = Read.get_rule_part(rule_part.id)

    # Assertion
    assert rule_part.rule_id == retrieved_rule_part.rule_id
    assert rule_part.block == retrieved_rule_part.block
    assert rule_part.verb == retrieved_rule_part.verb
  end

  test "get_rule_part/1 returns an error if the rule part is not found" do
    # Action
    error = Read.get_rule_part(98)

    # Assertion
    assert {:error, :rule_part_not_found} == error
  end

  test "list_rule_parts_by_rule_id/1 retrieves a list of rule parts by the rule ID" do
    # Setup
    attrs = %{rule_id: 2, block: "tester block1", verb: "verb", arguments: %{}}
    {:ok, rule_part1} = Create.create_rule_part(attrs)
    attrs = %{rule_id: 2, block: "tester block2", verb: "verb", arguments: %{}}
    {:ok, rule_part2} = Create.create_rule_part(attrs)

    # Action
    {:ok, [retrieved_rule_part1, retrieved_rule_part2]} = Read.list_rule_parts_by_rule_id(2)

    # Assertion
    assert rule_part1.rule_id == retrieved_rule_part1.rule_id
    assert rule_part1.block == retrieved_rule_part1.block
    assert rule_part1.verb == retrieved_rule_part1.verb
    assert rule_part2.rule_id == retrieved_rule_part2.rule_id
    assert rule_part2.block == retrieved_rule_part2.block
    assert rule_part2.verb == retrieved_rule_part2.verb
  end

  test "list_rule_parts_by_rule_id/1 returns an error if no rule parts are found" do
    # Action
    error = Read.list_rule_parts_by_rule_id(97)

    # Assertion
    assert {:error, :rule_part_not_found} == error
  end
end
