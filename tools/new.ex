import Wongi.Engine
import Wongi.Engine.DSL
{:ok, rule} = Tpe.Rule.Create.create_rule(%{name: "Rule 1", description: "a new rule"})


args = %{subject: "var(:planet)",  predicate: :satellite,  object: "var(:satellite)"}
attrs = %{rule_id: rule.id, block: "forall", verb: "has", arguments:  args}
{:ok, _} = Tpe.RulePart.Create.create_rule_part(attrs)
args = %{subject: "var(:planet)",  predicate: :mass,  object: "var(:planet_mass)"}
attrs = %{rule_id: rule.id, block: "forall", verb: "has", arguments: args}
{:ok, _} = Tpe.RulePart.Create.create_rule_part(attrs)
args =   %{subject: "var(:satellite)",  predicate: :mass,  object: "var(:sat_mass)"}
attrs = %{rule_id: rule.id, block: "forall", verb: "has", arguments: args}
{:ok, _} = Tpe.RulePart.Create.create_rule_part(attrs)
args =   %{subject: "var(:satellite)",  predicate: :distance,  object: "var(:distance)"}
attrs = %{rule_id: rule.id, block: "forall", verb: "has", arguments: args }
{:ok, _} = Tpe.RulePart.Create.create_rule_part(attrs)
args = %{name: :pull,  value: "&(6.674e-11 * &1[:sat_mass] * &1[:planet_mass] / :math.pow(&1[:distance], 2))"}
attrs = %{rule_id: rule.id, block: "forall", verb: "assign", arguments: args}
{:ok, _} = Tpe.RulePart.Create.create_rule_part(attrs)
args = %{ subject: "var(:satellite)", predicate: "pull", object: "var(:pull)"}
attrs = %{rule_id: rule.id, block: "do", verb: "generator", arguments: args}
{:ok, _} = Tpe.RulePart.Create.create_rule_part(attrs)

IO.puts("=====rule id " <> to_string(rule.id))

##### retrieve and eval
import Wongi.Engine.DSL

{:ok, %{ rule_parts: new_rule_parts, rule: _new_rule}} = Tpe.Rule.Read.get_rule_and_rule_parts(rule.id)



all = new_rule_parts |> Enum.reduce([], fn rule_part, acc ->
  #statement = apply(Wongi.Engine.DSL, String.to_atom(rule_part.verb), rule_part.arguments)
  #https://elixirforum.com/t/idiomatic-way-to-convert-from-one-struct-to-another/7499/2
#  statement = %{rule_part.arguments | __struct__: Wongi.Engine.DSL.Has}
#
arguments = Map.get(rule_part, :arguments)
verb = Map.get(rule_part, :verb)



arguments = Enum.reduce(arguments, %{}, fn {key, value}, acc ->
  new_value = Regex.run(~r/var\(:(.*)\)/, value, capture: :all_but_first)
  new_value = case new_value do
    [var] -> %Wongi.Engine.DSL.Var{name: String.to_atom(var)}
    nil -> String.to_atom(value)
    _ -> throw("Unknown value")
  end
  Map.put(acc, String.to_atom(key), new_value)
end)

statement =
case verb do
  "has" ->
    has(arguments.subject, arguments.predicate, arguments.object)

  "assign" ->
    #IO.inspect(arguments.value)
    assign(arguments.name, Code.eval_string(to_string(arguments.value))|>elem(0))

  "generator" ->
    gen(arguments.subject, arguments.predicate, arguments.object)

  _ ->
    throw("Unknown verb" <> rule_part.verb)
end
  case acc[String.to_atom(rule_part.block)] do
    nil ->
      put_in(acc, [String.to_atom(rule_part.block)], [statement])
    _->
      update_in(acc, [String.to_atom(rule_part.block)], & &1 ++ [statement])
  end
 end)

# IO.inspect(all)

# System.halt(0)
 rule =
  rule(
    all
  )

# IO.inspect(rule)


 engine =
   new()
   |> compile(rule)
   |> assert(:earth, :satellite, :moon)
   |> assert(:earth, :mass, 5.972e24)
   |> assert(:moon, :mass, 7.34767309e22)
   |> assert(:moon, :distance, 384_400.0e3)

 #  IO.inspect(engine)
 [wme] = engine |> select(:moon, :pull, :_) |> Enum.to_list()
 IO.inspect(wme.object)
