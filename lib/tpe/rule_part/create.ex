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

  @doc """
  create_rule_part for Has.

  This function takes in the rule_id, subject, predicate, and object as arguments and creates a simplified rule part.
  It constructs the arguments and attributes required for creating the rule part, and then calls the create_rule_part function.

  Example:
  has_rule_part(1, :item, :price, :price)

  Params:
  - rule_id: The ID of the rule.
  - subject: The subject of the rule part.
  - predicate: The predicate of the rule part.
  - object: The object of the rule part.

  Returns:
  The created rule part.
  """
  def has_rule_part(rule_id, subject, predicate, object) do
    args = %{
      subject: "var(:#{subject})",
      predicate: predicate,
      object: "var(:#{object})"
    }
    attrs = %{rule_id: rule_id, block: "forall", verb: "has", arguments: args}
    create_rule_part(attrs)
  end

  @doc """
  create_rule_part for Assign.
  Assigns a rule part to a rule with the given rule_id.

  Args:
  - rule_id: The ID of the rule to assign the rule part to.
  - name: The name of the rule part.
  - value: The value of the rule part.
  - eval: The evaluation of the rule part (optional, defaults to nil).
  - order: The order of the rule part (optional, defaults to 0).

  Returns:
  The newly created rule part.

  Examples:
  assign_rule_part(1, "part1", "value1")
  # => %Tpe.RulePart{...}

  assign_rule_part(2, "part2", "value2", "eval2", 1)
  # => %Tpe.RulePart{...}
  """
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

  # Filters the dependencies list based on the given names.
  #
  # Given a list of dependencies and a list of names of values not yet prioritized, this function filters the
  # dependencies list by taking elements from the beginning until it encounters
  # a dependency that is present in the names list. It stops filtering when it
  # finds a dependency that is already present in the names list.
  #
  # Params:
  # - deps: The list of dependencies to filter.
  # - names: The list of names to check against.
  #
  # Returns:
  # The filtered list of dependencies.
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

  # Checks the dependencies of a rule part against a list of names.
  #
  # The function scans the arguments of the rule part for atoms and then checks
  # if those atoms exist in the list of names. It returns true if all dependencies
  # are found, otherwise it returns false.
  #
  # Params:
  # - rule_part: The rule part to check for dependencies.
  # - names: The list of names to check against.
  #
  # Returns:
  # True if all dependencies are found, otherwise false.
  defp check_rule_part_deps(rule_part, names) do
    deps = scan_for_atoms(rule_part.arguments)
    checked_deps = check_deps(deps, names)
    Enum.count(checked_deps) == Enum.count(deps)
  end

  # Populates the assigns from the remains
  #
  # This function takes a `remains` map and extracts the first rule part from the `remaining_assigns` list.
  # It then checks if the rule part has any dependencies by calling `check_rule_part_deps/2` function.
  # If there are no dependencies, the rule part is removed from the `remaining_assigns` list and added to the `ordered_assigns` list.
  # If there are dependencies, the rule part is shifted to the end of the `remaining_assigns` list.
  #
  # Params:
  # - remains: The `remains` map containing the remaining assigns and names
  #
  # Returns:
  # The updated `remains` map with the assigns and names modified accordingly
  defp pop_assigns(remains) do
    rule_part = Enum.at(remains.remaining_assigns, 0)
    cond do
      nil == rule_part ->
        Map.put(remains, :remaining_assigns, List.delete(remains.remaining_assigns, rule_part))
      check_rule_part_deps(rule_part, remains.remaining_names) ->
        remains = Map.put(remains, :remaining_assigns, List.delete(remains.remaining_assigns, rule_part))
        rule_part = Map.put(rule_part, :order, remains.order)
        remains = Map.put(remains, :ordered_assigns, [rule_part] ++ remains.ordered_assigns)
        remains = Map.put(remains, :order, remains.order + 1)
        Map.put(remains, :remaining_names, List.delete(remains.remaining_names, Map.get(rule_part.arguments, "name")))
      true ->
        # if there are dependencies, we need to shift the first entry of remaining_assigns to the end
        remaining_assigns = List.delete(remains.remaining_assigns, rule_part)
        Map.put(remains, :remaining_assigns, remaining_assigns ++ [rule_part])
    end
  end

  # Orders the assigns in the remains list.
  #
  # If there are remaining assigns, it pops the assigns from the remains list
  # and repeats the process until there are no more remaining assigns.
  #
  # Params:
  # - remains: The `remains` list containing the remaining assigns.
  #
  # Returns:
  # The `remains` list with the remaining assigns ordered.
  defp order_assigns(remains) do
    case remains.remaining_assigns do
      true ->
        remains
      _ ->
        remains |> pop_assigns |> repeat_remains
    end
  end

  # Documentation for the `repeat_remains/1` function.
  #
  # This function checks if there are any remaining assigns in the `remains` struct.
  # If there are remaining assigns, it orders them using the `order_assigns/1` function.
  # If there are no remaining assigns, it returns the `remains` struct as is.
  # Not the most memory efficient way to do this, but the list will always be small.
  #
  # Params:
  # - remains: The `remains` list containing the remaining assigns.
  #
  # Returns:
  # The `remains` list with the remaining assigns ordered.
  defp repeat_remains(remains) do
    cond do
      Enum.count(remains.remaining_assigns) > 0 ->
        order_assigns(remains)
      true ->
        remains
    end
  end

  @doc """
  Generates a rule part with the given parameters.

  This function generates a rule part with the given rule_id, subject, predicate, and object.
  It constructs the arguments and attributes required for creating the rule part, and then calls the create_rule_part function.

  Examples:

  generator_rule_part(1, :item, :base_total, :base_total)

  Params:
  - rule_id: The ID of the rule.
  - subject: The subject of the rule part.
  - predicate: The predicate of the rule part.
  - object: The object of the rule part.

  Returns:
  The created rule part.
  """
  def generator_rule_part(rule_id, subject, predicate, object) do
    args = %{
      subject: "var(:#{subject})",
      predicate: predicate,
      object: "var(:#{object})"
    }
    attrs = %{rule_id: rule_id, block: "do", verb: "generator", arguments: args}
    create_rule_part(attrs)
  end

  # Scans the given arguments for atoms in the format "&<number>[:<atom_name>]"
  #
  # ## Examples
  #
  #     iex> scan_for_atoms(%{"value" => "&1[:foo] &2[:bar]"})
  #     ["foo", "bar"]
  #
  # ## Arguments
  #
  #   * `arguments` - A map containing the arguments to scan
  #
  # Returns a list of atom names found in the arguments
  defp scan_for_atoms(arguments) do
    Regex.scan(
      ~r/\&\d+\[:(\w*)\]/U, Map.get(arguments, "value"),
      capture: :all_but_first
    )
  end
end
