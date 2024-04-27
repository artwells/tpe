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

end
