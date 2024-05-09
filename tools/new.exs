

import Wongi.Engine
import Wongi.Engine.DSL

alias Tpe.RulePart.Read, as: RulePartRead

#  {:ok, rule} = Tpe.Rule.Create.create_rule(%{name: "Rule 1", description: "a new rule"})

# args = %{subject: "var(:planet)", predicate: :satellite, object: "var(:satellite)"}
# attrs = %{rule_id: rule.id, block: "forall", verb: "has", arguments: args}
# {:ok, _} = Tpe.RulePart.Create.create_rule_part(attrs)

# args = %{subject: "var(:planet)", predicate: :mass, object: "var(:planet_mass)"}
# attrs = %{rule_id: rule.id, block: "forall", verb: "has", arguments: args}
# {:ok, _} = Tpe.RulePart.Create.create_rule_part(attrs)

# args = %{subject: "var(:satellite)", predicate: :mass, object: "var(:sat_mass)"}
# attrs = %{rule_id: rule.id, block: "forall", verb: "has", arguments: args}
# {:ok, _} = Tpe.RulePart.Create.create_rule_part(attrs)

# args = %{subject: "var(:satellite)", predicate: :distance, object: "var(:distance)"}
# attrs = %{rule_id: rule.id, block: "forall", verb: "has", arguments: args}
# {:ok, _} = Tpe.RulePart.Create.create_rule_part(attrs)


# args = %{name: :pull,  eval: "dune", value: "&(6.674e-11 * &1[:sat_mass] * &1[:planet_mass] / :math.pow(&1[:distance], 2))"}
# attrs = %{rule_id: rule.id, block: "forall", verb: "assign", arguments: args}
# {:ok, _} = Tpe.RulePart.Create.create_rule_part(attrs)

# args = %{subject: "var(:satellite)", predicate: "pull", object: "var(:pull)"}
# attrs = %{rule_id: rule.id, block: "do", verb: "generator", arguments: args}
# {:ok, _} = Tpe.RulePart.Create.create_rule_part(attrs)

################################################################################3
#rule_id = rule.id
rule_id = 1069



all = RulePartRead.get_processed_rule_parts(rule_id)


rule = rule(all)
engine =
  new()
  |> compile(rule)
  |> assert(:earth, :satellite, :moon)
  |> assert(:earth, :mass, 5.972)
  |> assert(:moon, :mass, 7.34767309)
  |> assert(:moon, :distance, 384_400)

[wme] = engine |> select(:moon, :pull, :_) |> Enum.to_list()
IO.inspect(wme.object)
