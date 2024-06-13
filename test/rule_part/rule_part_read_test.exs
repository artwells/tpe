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


  test "get_rule_part/1 retrieves a rule part by its ID" do
    # Setup
    {:ok, rule} = Tpe.Rule.Create.create_rule(%{name: "Rule 1", description: "a new rule"})

    attrs = %{rule_id: rule.id, block: "tester block", verb: "verb", arguments: %{}}
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
    error = Read.get_rule_part(0)

    # Assertion
    assert {:error, :rule_part_not_found} == error
  end

  test "list_rule_parts_by_rule_id/1 retrieves a list of rule parts by the rule ID" do
    # Setup
    {:ok, rule} = Tpe.Rule.Create.create_rule(%{name: "Rule 1", description: "a new rule"})

    attrs = %{rule_id: rule.id, block: "tester block1", verb: "verb", arguments: %{}}
    {:ok, rule_part1} = Create.create_rule_part(attrs)
    attrs = %{rule_id: rule.id, block: "tester block2", verb: "verb", arguments: %{}}
    {:ok, rule_part2} = Create.create_rule_part(attrs)

    # Action
    {:ok, [retrieved_rule_part1, retrieved_rule_part2]} = Read.list_rule_parts_by_rule_id(rule.id)

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
    error = Read.list_rule_parts_by_rule_id(0)

    # Assertion
    assert {:error, :rule_part_not_found} == error
  end


    describe "get_processed_rule_parts/1" do
      test "returns the processed rule parts for a given rule ID" do
        {:ok, rule} = Tpe.Rule.Create.create_rule(%{name: "Rule 1", description: "a new rule"})
        attrs1 = %{rule_id: rule.id, block: "block1", verb: "has", arguments: %{subject: "Alice", predicate: "likes", object: "Bob"}}
        attrs2 = %{rule_id: rule.id, block: "block2", verb: "assign", arguments: %{name: "var1", value: "value1"}}
        {:ok, _} = Create.create_rule_part(attrs1)
        {:ok, _} = Create.create_rule_part(attrs2)

        expected1 = %{name: :var1, value: :value1}
        expected2 = %{subject: :Alice, predicate: :likes, object: :Bob}

        returned = Read.get_processed_rule_parts(rule.id)

        assert expected1  == Map.from_struct(hd(returned[:block2]))
        assert expected2.subject  == Map.from_struct(hd(returned[:block1])).subject
      end
      test "returns the processed rule parts for a given rule ID with compilation" do
        {:ok, rule} = Tpe.Rule.Create.create_rule(%{name: "Rule 1", description: "a new rule"})
        attrs1 = %{rule_id: rule.id, block: "block1", verb: "has", arguments: %{subject: "Alice", predicate: "likes", object: "Bob"}}
        attrs2 = %{rule_id: rule.id, block: "block2", verb: "assign", arguments: %{name: :var1,  eval: "dune", value: "4 * 6 / 2"}}

        {:ok, _} = Create.create_rule_part(attrs1)
        {:ok, _} = Create.create_rule_part(attrs2)

        returned = Enum.sort(Read.get_processed_rule_parts(rule.id))
        assert 12.0 = Map.from_struct(hd(returned[:block2]))[:value]

      end
    end
  end
