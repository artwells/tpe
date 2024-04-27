defmodule Tpe.RuleTest do
  use ExUnit.Case
  alias Tpe.Rule

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Tpe.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Tpe.Repo, {:shared, self()})
    :ok
  end

  test "changeset/2 builds and validates changesets for the 'rule' table" do
    rule = %Tpe.Rule{}
    params = %{name: "New Rule", type: "advanced"}

    changeset = Rule.changeset(rule, params)

    assert changeset.valid?
    assert changeset.params == %{name: "New Rule", type: "advanced"}
  end
end
