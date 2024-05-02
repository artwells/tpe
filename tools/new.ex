#import Wongi.Engine
# #import Wongi.Engine.DSL
# # # engine = new()
# # # engine = engine |> assert({:earth, :satellite, :moon})
# # # [fact] = engine |> select(:earth, :satellite, :_) |> Enum.to_list()

# # # IO.inspect(fact.object)
# # # # => :moon

# # # #########################3
# # # rule = rule("optional name", forall: [
# # #   {:earth, :satellite, :moon},
# # #   {:jupiter, :satellite, :io},
# # #   {:jupiter, :satellite, :europa},
# # #   {:jupiter, :satellite, :ganymede},
# # #   {:jupiter, :satellite, :callisto},
# # #   {:mars, :satellite, :deimos},
# # #   {:mars, :satellite, :phobos}
# # # ])

# # # IO.inspect(rule.ref)
# # # => #Reference<...>
# # #engine = engine |> compile(rule)

# # #################

# # rule =
# #   rule(
# #     forall: [
# #       has(var(:planet), :satellite, var(:satellite)),
# #       has(var(:planet), :mass, var(:planet_mass)),
# #       has(var(:satellite), :mass, var(:sat_mass)),
# #       has(var(:satellite), :distance, var(:distance)),
# #       assign(:pull, &(6.674e-11 * &1[:sat_mass] * &1[:planet_mass] / :math.pow(&1[:distance], 2)))
# #     ],
# #     do: [
# #       gen(var(:satellite), :pull, var(:pull))
# #     ]
# #   )

# # engine =
# #   new()
# #   |> compile(rule)
# #   |> assert(:earth, :satellite, :moon)
# #   |> assert(:earth, :mass, 5.972e24)
# #   |> assert(:moon, :mass, 7.34767309e22)
# #   |> assert(:moon, :distance, 384_400.0e3)

# # [wme] = engine |> select(:moon, :pull, :_) |> Enum.to_list()
# # IO.inspect(wme.object)


# #iex(38)> Enum.map(entity(engine,"Alice"), fn {a,b} -> {a,b} end)

 {:ok, rule} = Tpe.Rule.Create.create_rule(%{name: "Rule 1", description: "a new rule"})
 IO.puts("=====rule id " <> to_string(rule.id))


# attrs = %{rule_id: rule.id, block: "forall", verb: "has", arguments: %{subject: "var(:satellite)", object: ":distance", predicate: "var(:distance)"}}
# {:ok, _} = Tpe.RulePart.Create.create_rule_part(attrs)

# attrs = %{rule_id: rule.id, block: "forall", verb: "has", arguments: %{subject: "var(:planet)", object: ":mass", predicate: "var(:planet_mass)"}}
# {:ok, _} = Tpe.RulePart.Create.create_rule_part(attrs)

# attrs = %{rule_id: rule.id, block: "forall", verb: "has", arguments: %{subject: "var(:satellite)", object: ":mass", predicate: "var(:sat_mass)"}}
# {:ok, _} = Tpe.RulePart.Create.create_rule_part(attrs)

# attrs = %{rule_id: rule.id, block: "forall", verb: "has", arguments: %{subject: "var(:satellite)", object: ":distance", predicate: "var(:distance)"}}
# {:ok, _} = Tpe.RulePart.Create.create_rule_part(attrs)

# attrs = %{rule_id: rule.id, block: "forall", verb: "assign", arguments: %{subject: :pull, object: "&(6.674e-11 * &1[:sat_mass] * &1[:planet_mass] / :math.pow(&1[:distance], 2))"}}
# {:ok, _} = Tpe.RulePart.Create.create_rule_part(attrs)

# attrs = %{rule_id: rule.id, block: "do", verb: "gen", arguments: %{subject: "var(:satellite)", object: :pull, predicate: "var(:pull)"}}
# {:ok, _} = Tpe.RulePart.Create.create_rule_part(attrs)
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
args = %{subject: "pull", object: "var(:pull)", predicate: "var(:satellite)"}
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
statement =
case rule_part.verb do
  "has" ->
    %Wongi.Engine.DSL.Has{subject: var(String.to_atom(rule_part.arguments.subject)), predicate: String.to_atom(rule_part.arguments.predicate), object: var(String.to_atom(rule_part.arguments.object))}
  "assign" ->
    %Wongi.Engine.DSL.Assign{name: String.to_atom(rule_part.arguments.subject), value: String.to_atom(rule_part.arguments.object)}
  "generator" ->
    %Wongi.Engine.Action.Generator{template: WME.new(var(String.to_atom(rule_part.arguments.subject)), String.to_atom(rule_part.arguments.object), var(String.to_atom(rule_part.arguments.predicate)))}
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


IO.inspect(all)

# all_list2 = [all]
#add_element = fn list, element -> [element | list] end
# all_list =  [
#     forall: [
#       has(var(:planet), :satellite, var(:satellite)),
#       has(var(:planet), :mass, var(:planet_mass)),
#       has(var(:satellite), :mass, var(:sat_mass)),
#       has(var(:satellite), :distance, var(:distance)),
#       assign(:pull, &(6.674e-11 * &1[:sat_mass] * &1[:planet_mass] / :math.pow(&1[:distance], 2)))
#     ],
#     do: [
#       gen(var(:satellite), :pull, var(:pull))
#     ]
#   ]


  # all_list2 = Enum.into(all_list2, %{})
  #  rule = rule(
  #    all_list2
  #  )

#IO.inspect(all_list)
#IO.inspect(all_list2)

# engine =
#   new()
#   |> compile(rule)
#   |> assert(:earth, :satellite, :moon)
#   |> assert(:earth, :mass, 5.972e24)
#   |> assert(:moon, :mass, 7.34767309e22)
#   |> assert(:moon, :distance, 384_400.0e3)

# [wme] = engine |> select(:moon, :pull, :_) |> Enum.to_list()
# IO.inspect(wme.object)


#all_rule = apply(Wongi.Engine.DSL, :rule, all_list)

#IO.inspect(all_rule)
