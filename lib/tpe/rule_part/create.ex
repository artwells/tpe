defmodule Tpe.RulePart.Create do
  @moduledoc """
  This module provides functions for creating rule parts in the Tpe application.
  """

  use Ecto.Schema
  use Ecto.Repo, otp_app: :my_app, adapter: Ecto.Adapters.Postgres

  @doc """
  Creates a new rule part with the given attributes.

  ## Examples
  iex> {:ok, rule} = Tpe.Rule.Create.create_rule(%{name: "Rule 1", description: "a new rule"})
  iex> {:ok, rp} = Tpe.RulePart.Create.create_rule_part(%{rule_id: rule.id, block: "block", verb: "verb", arguments: %{}})
  iex> part = Map.from_struct(rp)
  iex> part.rule_id
  rule.id
  """
  def create_rule_part(attrs \\ %{}) do
    attrs = Map.put(attrs, :updated_at, DateTime.utc_now())

    rule_part = %Tpe.RulePart{}
    |> Tpe.RulePart.changeset(attrs)
    |> Tpe.Repo.insert()
    rule_part
  end

  # create_rule_part for Has.
  #
  # This function takes in the rule_id, subject, predicate, and object as arguments and creates a simplified rule part.
  # It constructs the arguments and attributes required for creating the rule part, and then calls the create_rule_part function.
  #
  # Params:
  # - rule_id: The ID of the rule.
  # - subject: The subject of the rule part.
  # - predicate: The predicate of the rule part.
  # - object: The object of the rule part.
  #
  # Returns:
  # The created rule part.
  def has_rule_part(rule_id, subject, predicate, object) do
    args = %{
      subject: "var(:#{subject})",
      predicate: predicate,
      object: "var(:#{object})"
    }
    attrs = %{rule_id: rule_id, block: "forall", verb: "has", arguments: args}
    create_rule_part(attrs)
  end



  def assign_rule_part(rule_id, name, value, eval \\ nil, order \\ 0) do
    args = %{name: name, eval: eval, value: value}
    attrs = %{rule_id: rule_id, order: order, block: "forall", verb: "assign", arguments: args}
    new_rule = create_rule_part(attrs)
    {:ok, assigns} = Tpe.RulePart.Read.list_rule_parts_by_rule_id(rule_id, "assign")

    case Enum.count(assigns) do
      n when n < 2 ->
        nil
      _ ->
        names = assigns |> Enum.reduce([], fn rule_part, acc ->
          [Map.get(rule_part.arguments, "name")] ++ acc
        end)

        remains = %{
          remaining_assigns: assigns,
          remaining_names: names,
          ordered_assigns: [],
          order: 0
        }
        ordered_assigns = order_assigns(remains).ordered_assigns
        Enum.each(ordered_assigns, fn rule_part ->
          Tpe.RulePart.Update.update_rule_part(rule_part.id, %{order: Map.get(rule_part, :order)})
        end)
    end
    new_rule
  end

  defp check_deps(deps, names) do
    Enum.take_while(deps, fn [dep] ->
      dep = to_string(dep)
      if Enum.member?(names, dep) do
        false
      else
        true
      end
    end)
  end

  defp check_rule_part_deps(rule_part, names) do
    deps = scan_for_atoms(rule_part.arguments)
    checked_deps = check_deps(deps, names)
    Enum.count(checked_deps) == Enum.count(deps)
  end

  defp pop_assigns(remains) do
        rule_part = Enum.at(remains.remaining_assigns, 0)
        cond do
          nil == rule_part ->
            Map.put(remains, :remaining_assigns, List.delete(remains.remaining_assigns, rule_part))
          check_rule_part_deps(rule_part, remains.remaining_names)->
            remains = Map.put(remains, :remaining_assigns, List.delete(remains.remaining_assigns, rule_part))
            rule_part = Map.put(rule_part, :order, remains.order)
            remains = Map.put(remains, :ordered_assigns, [rule_part] ++ remains.ordered_assigns)
            remains = Map.put(remains, :order, remains.order + 1)
            Map.put(remains, :remaining_names, List.delete(remains.remaining_names, Map.get(rule_part.arguments, "name")))
          true ->
            #if there are dependencies, we need to shift the first entry of remaining_assigns to the end
            remaining_assigns = List.delete(remains.remaining_assigns, rule_part)
            Map.put(remains, :remaining_assigns, remaining_assigns ++  [rule_part])
        end
  end

  defp order_assigns(remains) do
    case remains.remaining_assigns do
      true ->
        remains
      _ ->
        remains |> pop_assigns |> tail_remains
    end
  end

  defp tail_remains(remains) do
    cond do
      Enum.count(remains.remaining_assigns) > 0 ->
        order_assigns(remains)
      true ->
        remains
    end
  end


  def generator_rule_part(rule_id, subject, predicate, object) do
    args = %{
      subject: "var(:#{subject})",
      predicate: predicate,
      object: "var(:#{object})"
    }
    attrs = %{rule_id: rule_id, block: "do", verb: "generator", arguments: args}
    create_rule_part(attrs)
  end

  defp scan_for_atoms(arguments) do
    Regex.scan(
      ~r/\&\d+\[:(\w*)\]/U, Map.get(arguments, "value"),
      capture: :all_but_first
    )
  end
end
