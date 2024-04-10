defmodule Tpe.RulePartTest do
  use ExUnit.Case
  doctest Tpe.RulePart, import: true
  alias Tpe.RulePart

  describe "changeset/2" do
    test "casts and validates the rule part changeset" do
      rule_part = %RulePart{}
      now = DateTime.utc_now()
      params = %{rule_id: 1, block: "some block", verb: "some verb", arguments: %{}, updated_at: now}

      changeset = RulePart.changeset(rule_part, params)

      assert changeset.valid?
      assert %{rule_id: 1, block: "some block", verb: "some verb", arguments: %{}, updated_at: now} == changeset.changes
    end

    test "requires rule_id, block, verb, and arguments" do
      rule_part = %RulePart{}
      params = %{}

      changeset = RulePart.changeset(rule_part, params)

      assert {"can't be blank", [validation: :required]} = changeset.errors[:rule_id]
      assert {"can't be blank", [validation: :required]} = changeset.errors[:block]
      assert {"can't be blank", [validation: :required]} = changeset.errors[:verb]
      assert {"can't be blank", [validation: :required]} = changeset.errors[:arguments]
    end
  end
end
