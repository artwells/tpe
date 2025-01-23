defmodule Tpe.Rule.DeleteTest do
  use ExUnit.Case
  alias Tpe.Rule.Delete
  alias Tpe.Rule.Create

  doctest(Tpe.Rule.Delete)

  setup do
    Tpe.TestTools.sandbox_connection()
    :ok
  end

  test "delete_rule/1 deletes a rule with the given ID from the database" do
    attrs = %{name: "Test Rule", description: "Test Description", type: "basic"}
    {:ok, rule} = Create.create_rule(attrs)

    assert {:ok, _} = Delete.delete_rule(rule.id)

    assert {:error, _} = Tpe.Rule.Delete.delete_rule(rule.id)
  end

  test "delete_rule/1 returns an error tuple if rule is not found" do
    assert {:error, "Rule not found"} = Delete.delete_rule(999)
  end
end
