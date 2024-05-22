
qimport Wongi.Engine
import Wongi.Engine.DSL

alias Tpe.RulePart.Read, as: RulePartRead

{:ok, rule} = Tpe.Rule.Create.create_rule(%{name: "Rule 1", description: "a new rule"})

{:ok, _} = Tpe.RulePart.Create.has_rule_part(rule.id, :planet, :satellite, :satellite)
{:ok, _} = Tpe.RulePart.Create.has_rule_part(rule.id, :planet, :mass, :planet_mass)
{:ok, _} = Tpe.RulePart.Create.has_rule_part(rule.id, :satellite, :mass, :sat_mass)
{:ok, _} = Tpe.RulePart.Create.has_rule_part(rule.id, :satellite, :distance, :distance)
{:ok, _} = Tpe.RulePart.Create.assign_rule_part(rule.id, :pull, "&( 0.5 * &1[:sat_mass] * &1[:planet_mass] * &1[:distance])", "dune")
{:ok, _} = Tpe.RulePart.Create.generator_rule_part(rule.id, :satellite, :pull, :pull)

{:ok, rule2} = Tpe.Rule.Create.create_rule(%{name: "Rule 2", description: "some a new rule"})

{:ok, _} = Tpe.RulePart.Create.has_rule_part(rule2.id, :planet, :satellite, :satellite)
{:ok, _} = Tpe.RulePart.Create.has_rule_part(rule2.id, :planet, :mass, :planet_mass)
{:ok, _} = Tpe.RulePart.Create.has_rule_part(rule2.id, :satellite, :mass, :sat_mass)
{:ok, _} = Tpe.RulePart.Create.has_rule_part(rule2.id, :satellite, :distance, :distance)
{:ok, _} = Tpe.RulePart.Create.assign_rule_part(rule2.id, :pull2, "&(&1[:sat_mass] * &1[:planet_mass] * &1[:distance])", "dune")
{:ok, _} = Tpe.RulePart.Create.generator_rule_part(rule2.id, :satellite, :pull2, :pull2)


all = RulePartRead.get_processed_rule_parts(rule.id)
all2 = RulePartRead.get_processed_rule_parts(rule2.id)


rule = rule(all)
rule2 = rule(all2)
engine =
  new()
  |> compile(rule2)
  |> compile(rule)
  |> assert(:earth, :satellite, :moon)
  |> assert(:earth, :mass, 5.972)
  |> assert(:moon, :mass, 7.34767309)
  |> assert(:moon, :distance, 3)
#  engine = new() |> compile(rule) |> assert(:earth, :satellite, :moon) |> assert(:earth, :mass, 5.972) |> assert(:moon, :mass, 7.34767309)   |> assert(:moon, :distance, 384_400)
[token] = engine |> tokens(rule2.ref) |> Enum.to_list()
#[wme] = engine |> select(:moon, :pull2, :_) |> Enum.to_list()
IO.inspect(engine)
