
import Wongi.Engine
#import Wongi.Engine.DSL

#alias Tpe.RulePart.Read, as: RulePartRead
#alias Tpe.Rule.Read, as: RuleRead




{:ok, rule} = Tpe.Rule.Create.create_rule(%{name: "promo 1", description: "a new promo"})


{:ok, _} = Tpe.RulePart.Create.generator_rule_part(rule.id, :item, :base_total, :base_total)
{:ok, _} = Tpe.RulePart.Create.generator_rule_part(rule.id, :item, :discounted_total, :discounted_total)
{:ok, _} = Tpe.RulePart.Create.has_rule_part(rule.id, :item, :price, :price)
{:ok, _} = Tpe.RulePart.Create.has_rule_part(rule.id, :item, :quantity, :quantity)
{:ok, _} = Tpe.RulePart.Create.has_rule_part(rule.id, :item, :discount, :discount)
{:ok, _} = Tpe.RulePart.Create.assign_rule_part(rule.id, :base_total, "&(&1[:price] * &1[:quantity])", "dune")
{:ok, _} = Tpe.RulePart.Create.assign_rule_part(rule.id, :discounted_total, "&(&1[:base_total]) * &1[:discount]", "dune")

engine = Tpe.Engine.Create.create_engine()

wmes = [
  {:item, :price, 10},
  {:item, :quantity, 2},
  {:item, :discount, 0.5},
  {:item, :discount, 0.23}
]
engine = engine |> Tpe.Engine.Update.assert_wmes(wmes)

wme = engine |> select(:item, :_, :_) |> Enum.to_list()
IO.inspect(wme)
