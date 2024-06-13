defmodule Tpe.Rule.UpdateTest do
  use ExUnit.Case
  alias Tpe.Rule.Update
  alias Tpe.Rule.Create
  doctest(Tpe.Rule.Update)

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Tpe.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Tpe.Repo, {:shared, self()})
    :ok
  end

  test "update_rule/2 updates a rule with the given ID and attributes" do
    attrs = %{name: "New Rule"}

    {:ok, rule} = Create.create_rule(%{name: "Rule 1", description: "a new rule"})
    {:ok, updated_rule} = Update.update_rule(rule.id, attrs)

    assert updated_rule.name == "New Rule"
    assert DateTime.compare(updated_rule.updated_at, DateTime.utc_now()) == :lt
  end

  test "update_rule/2 returns an error tuple if the rule is not found" do
    attrs = %{name: "New Rule"}

    {:error, :rule_not_found} = Update.update_rule(0, attrs)
  end
end
