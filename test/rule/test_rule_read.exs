defmodule Tpe.Rule.ReadTest do
  use ExUnit.Case
  alias Tpe.Rule.Read
  alias Tpe.Rule.Create
  doctest(Tpe.Rule.Read)

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Tpe.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Tpe.Repo, {:shared, self()})
    :ok
  end

  test "get_rule/1 retrieves a rule by its ID" do
    attrs = %{rule_id: 9, name: "test rule", description: "test description"}
    {:ok, rule} = Create.create_rule(attrs)

    {:ok, rule1} = Read.get_rule(rule.id)

    assert rule1.name == "test rule"
  end

  test "get_rule/1 returns an error tuple if rule is not found" do
  {:error, :rule_not_found} = Read.get_rule(0)
  end

  test "get_rule_and_rule_parts/1 retrieves a rule and its rule parts by ID" do
    attrs = %{name: "test rule", description: "test description"}
    {:ok, rule} = Create.create_rule(attrs)
    rule_part_attrs = [
      %{rule_id: rule.id, block: "tester block 1", verb: "verb", arguments: %{}},
      %{rule_id: rule.id, block: "tester block 2", verb: "verb", arguments: %{}}
    ]
    Enum.each(rule_part_attrs, &Tpe.RulePart.Create.create_rule_part/1)

    {:ok, %{rule: rule, rule_parts: rule_parts}} = Read.get_rule_and_rule_parts(rule.id)

    assert rule.name == "test rule"
    assert length(rule_parts) == 2
  #  assert Enum.all?(rule_parts, fn rp -> rp.rule_id == rule.id end)
  end

  test "get_rule_and_rule_parts/1 returns an error tuple if rule is not found" do
    {:error, :rule_not_found} = Read.get_rule_and_rule_parts(0)
  end





end
