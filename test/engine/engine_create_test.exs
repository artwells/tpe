defmodule Tpe.Engine.CreateTest do
  use ExUnit.Case, async: false

  alias Tpe.Engine.Create

  setup do
    Tpe.TestTools.sandbox_connection()
    :ok
  end

  test "create_engine/0 compiles and adds all valid rule parts to the engine" do
    # Prepare test data
    {:ok, rule} = Tpe.Rule.Create.create_rule(%{name: "promo 1", description: "a new promo"})

    {:ok, _} = Tpe.RulePart.Create.generator_rule_part(rule.id, :item, :base_total, :base_total)

    {:ok, _} =
      Tpe.RulePart.Create.generator_rule_part(
        rule.id,
        :item,
        :discounted_total,
        :discounted_total
      )

    {:ok, _} = Tpe.RulePart.Create.prep_rule_part(rule.id, "forall", "has", :item, :price, :price)

    {:ok, _} =
      Tpe.RulePart.Create.prep_rule_part(rule.id, "forall", "has", :item, :quantity, :quantity)

    {:ok, _} =
      Tpe.RulePart.Create.prep_rule_part(rule.id, "forall", "has", :item, :discount, :discount)

    {:ok, _} =
      Tpe.RulePart.Create.assign_rule_part(
        rule.id,
        "forall",
        :base_total,
        "&(&1[:price] * &1[:quantity])",
        "dune"
      )

    {:ok, _} =
      Tpe.RulePart.Create.assign_rule_part(
        rule.id,
        "forall",
        :discounted_total,
        "&(&1[:base_total]) * &1[:discount]",
        "dune"
      )

    # Execute the function
    engine = Create.create_engine()

    # test that it has the correct number of subscriptions
    assert 2 < Enum.count(engine.alpha_subscriptions)

    # test that it is the correct type
    assert Wongi.Engine.Rete == engine.__struct__

    # Assert that all rule parts are compiled and added to the engine
  end
end
