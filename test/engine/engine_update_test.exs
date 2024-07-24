defmodule Tpe.Engine.UpdateTest do
  use ExUnit.Case
  import Wongi.Engine

  alias Tpe.Engine.Create
  alias Tpe.TestTools

  setup do
    TestTools.sandbox_connection()
    :ok
  end

  test "assert_wmes/2 asserts a list of Working Memory Elements (WMEs) in the engine" do
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
      Tpe.RulePart.Create.prep_rule_part(
        rule.id,
        "forall",
        "has",
        :item,
        :quantity,
        :quantity,
        "Wongi.Engine.DSL.gte( var(:quantity), 1)"
      )

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

    wmes = [
      {:item, :price, 10},
      {:item, :quantity, 2},
      {:item, :discount, 0.5}
    ]

    engine = engine |> Tpe.Engine.Update.assert_wmes(wmes)

    wme_result = engine |> select(:item, :discounted_total, 10.0) |> Enum.to_list()
    assert 1 == Enum.count(wme_result)
    assert Wongi.Engine.WME.new(:item, :discounted_total, 10.0) == wme_result |> hd()
    # confirm that the filters are added to the beta table
    join =
      engine.beta_table
      |> Enum.filter(fn {_key, val} -> is_map_key(val, :filters) && !is_nil(val.filters) end)
      |> hd()
      |> elem(1)

    assert %Wongi.Engine.Filter.GTE{
             a: %Wongi.Engine.DSL.Var{name: :quantity},
             b: 1
           } == join.filters
  end
end
