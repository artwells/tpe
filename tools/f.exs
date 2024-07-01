
import Wongi.Engine




{:ok, rule} = Tpe.Rule.Create.create_rule(%{name: "promo 1", description: "a new promo"})


{:ok, _} = Tpe.RulePart.Create.generator_rule_part(rule.id, :item, :base_total, :base_total)
{:ok, _} = Tpe.RulePart.Create.generator_rule_part(rule.id, :item, :discounted_total, :discounted_total)
{:ok, _} = Tpe.RulePart.Create.prep_rule_part(rule.id, "forall", "has", :item, :price, :price )
{:ok, _} = Tpe.RulePart.Create.prep_rule_part(rule.id, "forall", "has", :item, :quantity, :quantity, "Wongi.Engine.DSL.gte( var(:quantity), 1)")
{:ok, _} = Tpe.RulePart.Create.prep_rule_part(rule.id, "forall", "has", :item, :discount, :discount)
{:ok, _} = Tpe.RulePart.Create.assign_rule_part(rule.id, "forall", :base_total, "&(&1[:price] * &1[:quantity])", "dune")
{:ok, _} = Tpe.RulePart.Create.assign_rule_part(rule.id, "forall",:discounted_total, "&(&1[:base_total]) * &1[:discount]", "dune")

engine = Tpe.Engine.Create.create_engine()


wmes = [
  {:item, :price, 10},
  {:item, :quantity, 2},
  {:item, :discount, 0.5},
  {:item, :discount, 0.23}
]
engine = engine |> Tpe.Engine.Update.assert_wmes(wmes)

# engine.beta_table
# |> Enum.filter(fn {key,val} ->  is_map_key(val, :filters) && !is_nil(val.filters) end)

# |> hd()
# |> elem(1)
# |> IO.inspect()
#IO.inspect(engine.beta_table)


 wme = engine |> select(:item, :_, :_) |> Enum.to_list()
#  [:__struct__, :productions, :beta_table, :overlay, :alpha_subscriptions,
#  :beta_subscriptions, :beta_root, :op_queue, :processing]
 IO.inspect(wme)
