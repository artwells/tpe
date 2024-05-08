defmodule Tpe.Tool do


import Wongi.Engine
import Wongi.Engine.DSL

 {:ok, rule} = Tpe.Rule.Create.create_rule(%{name: "Rule 1", description: "a new rule"})

args = %{subject: "var(:planet)", predicate: :satellite, object: "var(:satellite)"}
attrs = %{rule_id: rule.id, block: "forall", verb: "has", arguments: args}
{:ok, _} = Tpe.RulePart.Create.create_rule_part(attrs)

args = %{subject: "var(:planet)", predicate: :mass, object: "var(:planet_mass)"}
attrs = %{rule_id: rule.id, block: "forall", verb: "has", arguments: args}
{:ok, _} = Tpe.RulePart.Create.create_rule_part(attrs)

args = %{subject: "var(:satellite)", predicate: :mass, object: "var(:sat_mass)"}
attrs = %{rule_id: rule.id, block: "forall", verb: "has", arguments: args}
{:ok, _} = Tpe.RulePart.Create.create_rule_part(attrs)

args = %{subject: "var(:satellite)", predicate: :distance, object: "var(:distance)"}
attrs = %{rule_id: rule.id, block: "forall", verb: "has", arguments: args}
{:ok, _} = Tpe.RulePart.Create.create_rule_part(attrs)


args = %{name: :pull,  eval: "dune", value: "&(6.674e-11 * &1[:sat_mass] * &1[:planet_mass] / :math.pow(&1[:distance], 2))"}
attrs = %{rule_id: rule.id, block: "forall", verb: "assign", arguments: args}
{:ok, _} = Tpe.RulePart.Create.create_rule_part(attrs)

args = %{subject: "var(:satellite)", predicate: "pull", object: "var(:pull)"}
attrs = %{rule_id: rule.id, block: "do", verb: "generator", arguments: args}
{:ok, _} = Tpe.RulePart.Create.create_rule_part(attrs)

{:ok, %{rule_parts: new_rule_parts, rule: _new_rule}} = Tpe.Rule.Read.get_rule_and_rule_parts(rule.id)

new_rule_parts = Enum.sort_by(new_rule_parts, &Map.fetch(&1, :verb), :desc)



all = new_rule_parts |> Enum.reduce([], fn rule_part, acc ->
  arguments = Map.get(rule_part, :arguments)
  verb = Map.get(rule_part, :verb)

  arguments = Enum.reduce(arguments, %{}, fn {key, value}, acc ->
    value = if(is_binary(value)) do
      new_value = Regex.run(~r/var\(:(.*)\)/, value, capture: :all_but_first)
        case new_value do
          [var] -> %Wongi.Engine.DSL.Var{name: String.to_atom(var)}
          _ -> String.to_atom(value)
        end
      else
        value
    end
    Map.put(acc, String.to_atom(key), value)
  end)


  statement =
    case verb do
      "has" ->
        has(arguments.subject, arguments.predicate, arguments.object)

      "assign" ->
        value =
          case to_string(arguments.eval) do
            "dune" ->
              dune_test = Dune.eval_string(to_string(arguments.value))
              if is_binary(dune_test.inspected) do
                Code.eval_string(to_string(arguments.value))|>elem(0)

              else
                arguments.value
              end
            _ ->
                arguments.value
          end
        assign(arguments.name, value)
      "generator" ->
        gen(arguments.subject, arguments.predicate, arguments.object)

      _ ->
        throw("Unknown verb" <> rule_part.verb)
    end
  case acc[String.to_atom(rule_part.block)] do
    nil ->
      put_in(acc, [String.to_atom(rule_part.block)], [statement])
    _ ->
      update_in(acc, [String.to_atom(rule_part.block)], & &1 ++ [statement])
  end
end)

# def alphabetize(string, alphabet \\ @default_alphabet) do
#   list = String.split(string, "", trim: true)
#   sorted = Enum.sort(list,
#     fn (a, b) ->
#       compare_alpha?(a, b, alphabet)
#     end)
#   Enum.join(sorted)
# end


def tsort_order(rule_part) do
  case rule_part.block do
    "forall" -> 1
    "assign" -> 2
    _ -> 3
  end
end



rule = rule(all)
engine =
  new()
  |> compile(rule)
engine = engine
  |> assert(:earth, :satellite, :moon)
  |> assert(:earth, :mass, 5.972)
  |> assert(:moon, :mass, 7.34767309)
  |> assert(:moon, :distance, 384_400)

[wme] = engine |> select(:moon, :pull, :_) |> Enum.to_list()
IO.inspect(wme.object)




engine =
  new()
  |> compile(rule)
engine = engine
  |> assert(:earth, :satellite, :moon)
  |> assert(:earth, :mass, 5.972)
  |> assert(:moon, :mass, 7.34767309)
  |> assert(:moon, :distance, 384_400)

[wme] = engine |> select(:moon, :pull, :_) |> Enum.to_list()
IO.inspect(wme.object)



[wme] = engine |> select(:moon, :pull, :_) |> Enum.to_list()
IO.inspect(wme.object)
end
