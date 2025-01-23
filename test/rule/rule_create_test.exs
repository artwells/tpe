defmodule Tpe.Rule.CreateTest do
  use ExUnit.Case, async: false
  alias Tpe.Rule.Create
  doctest(Tpe.Rule.Create)

  setup do
    Tpe.TestTools.sandbox_connection()
    :ok
  end

  test "create_rule/1 creates a new rule with the given attributes" do
    attrs = %{name: "Rule 1", description: "a new rule"}

    {:ok, rule} = Create.create_rule(attrs)

    assert rule.name == "Rule 1"
    assert rule.description == "a new rule"
    assert rule.type == "basic"
    assert DateTime.compare(rule.updated_at, DateTime.utc_now()) == :lt
  end

  test "create_rule/1 returns an error tuple if creation fails" do
    attrs = %{description: "Invalid Rule"}

    {:error, _} = Create.create_rule(attrs)
  end
end
