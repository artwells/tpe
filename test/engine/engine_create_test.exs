defmodule Tpe.Engine.CreateTest do
  use ExUnit.Case
  alias Tpe.Engine.Create
  alias Tpe.TestTools

  setup do
    TestTools.sandbox_connection()
    :ok
  end

  test "create_engine/0 compiles and adds all valid rule parts to the engine" do
    # Prepare test data
    {:ok, rule} = Tpe.Rule.Create.create_rule(%{name: "promo 1", description: "a new promo"})

    {:ok, _} = Tpe.RulePart.Create.generator_rule_part(rule.id, :item, :base_total, :base_total)
    {:ok, _} = Tpe.RulePart.Create.generator_rule_part(rule.id, :item, :discounted_total, :discounted_total)
    {:ok, _} = Tpe.RulePart.Create.has_rule_part(rule.id, :item, :price, :price)
    {:ok, _} = Tpe.RulePart.Create.has_rule_part(rule.id, :item, :quantity, :quantity)
    {:ok, _} = Tpe.RulePart.Create.has_rule_part(rule.id, :item, :discount, :discount)
    {:ok, _} = Tpe.RulePart.Create.assign_rule_part(rule.id, :base_total, "&(&1[:price] * &1[:quantity])", "dune")
    {:ok, _} = Tpe.RulePart.Create.assign_rule_part(rule.id, :discounted_total, "&(&1[:base_total]) * &1[:discount]", "dune")

    # Execute the function
    engine = Create.create_engine()

    # test that it has the correct number of subscriptions
    assert 3 == Enum.count(engine.alpha_subscriptions)

    # test that it is the correct type
    assert Wongi.Engine.Rete == engine.__struct__

    # Assert that all rule parts are compiled and added to the engine
  end
end
