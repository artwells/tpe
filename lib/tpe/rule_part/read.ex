
defmodule Tpe.RulePart.Read do
#@compile ({:nowarn_unused_function, {:process_arguments, 1}})
# @compile {:nowarn_unused_function, {:gather_rule_parts, 2}}
# not sure what to do about this

@moduledoc """
  This module provides functions for reading rule parts from the database.
  """

  use Ecto.Schema
  use Ecto.Repo, otp_app: :my_app, adapter: Ecto.Adapters.Postgres
  import Ecto.Query, only: [from: 2]

  @doc """
  Retrieves a rule part by its ID.

  ## Examples
  iex> {:ok, rule} = Tpe.Rule.Create.create_rule(%{name: "Rule 1", description: "a new rule"})
  iex> attrs = %{rule_id: rule.id, block: "tester block", verb: "verb", arguments: %{}}
  iex> {:ok, rule_part1} = Create.create_rule_part(attrs)
  iex> {:ok, rule_part1} = Tpe.RulePart.Read.get_rule_part(rule_part1.id)
  iex> rule_part1.rule_id
  rule.id
  """
  def get_rule_part(id) do
    rule_part = Tpe.Repo.get(Tpe.RulePart, id)
    cond do
      rule_part == nil ->
        {:error, :rule_part_not_found}

      true ->
        {:ok, rule_part}
    end
  end

  @doc """
  Retrieves a list of rule parts by the rule ID.

  ## Examples
  iex> {:ok, rule} = Tpe.Rule.Create.create_rule(%{name: "Rule 1", description: "a new rule"})
  iex> attrs = %{rule_id: rule.id, block: "tester block", verb: "verb", arguments: %{}}
  iex> {:ok, _} = Create.create_rule_part(attrs)
  iex> attrs = %{rule_id: rule.id, block: "tester block", verb: "verb", arguments: %{}}
  iex> {:ok, _} = Create.create_rule_part(attrs)
  iex> {:ok, [rule_part_1, _]} = Tpe.RulePart.Read.list_rule_parts_by_rule_id(rule.id)
  iex> rule_part_1.rule_id
  rule.id
  """
  def list_rule_parts_by_rule_id(rule_id, verb \\ nil) do
    rule_parts = case verb do
      nil ->
        Tpe.Repo.all(from(rp in Tpe.RulePart, where: rp.rule_id == ^rule_id))
      _ ->
        Tpe.Repo.all(from(rp in Tpe.RulePart, where: rp.rule_id == ^rule_id and rp.verb == ^verb))
    end
    cond do
      rule_parts in [nil, []] ->
        {:error, :rule_part_not_found}

      true ->
        {:ok, rule_parts}
    end
  end



  # Sorts and gathers rule parts based on specific criteria.
    #
    # This function sorts and gathers rule parts based on the order and the type of rule part.
    #
    # Params:
    # - rule_parts: A list of rule parts to be sorted and gathered.
    #
    # Returns:
    # A sorted list of rule parts.
    defp sort_and_gather(rule_parts) do
      rule_parts
      |> Enum.sort_by(&Map.get(&1.arguments, "order"))
        |> Enum.sort_by(fn
        %{verb: "has"} -> 0
        %{verb: "assign"} -> 1
        %{block: "do"} -> 2
      end)
    end

  # Processes the arguments and returns a map with atom keys and corresponding values.
  #
  # Arguments:
  #   - arguments: a list of key-value pairs
  #
  # Returns:
  #   - a map with atom keys and corresponding values
  defp process_arguments(arguments) do
    Enum.reduce(arguments, %{}, fn {key, value}, acc ->
      value = if is_binary(value) do
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
  end

  # Retrieves the statement based on the given rule_part.
  #
  # Args:
  #   - rule_part: A map representing a rule part.
  #
  # Returns:
  #   The statement corresponding to the rule_part.
  #
  # Raises:
  #   - "Unknown verb" if the verb in the rule_part is not recognized.

  defp get_statement(rule_part) do
    import Wongi.Engine.DSL
    arguments = Map.get(rule_part, :arguments)
    arguments = arguments |> process_arguments()

    verb = Map.get(rule_part, :verb)

    case verb do
      "has" ->
        has(arguments.subject, arguments.predicate, arguments.object)

      "assign" ->
        eval = Map.get(arguments, :eval, nil)
        value =
          case to_string(eval) do
            "dune" ->
              dune_test = Dune.eval_string(to_string(arguments.value), timeout: 100)
              if is_binary(dune_test.inspected) do
                Code.eval_string(to_string(arguments.value)) |> elem(0)
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
  end

  # Gathers rule parts and groups them by block
  #
  # This function takes a list of rule parts and groups them by their associated block.
  # Each rule part consists of a statement and a block. The function iterates over the
  # rule parts and adds the statement to the corresponding block in the accumulator.
  #
  # Params:
  # - rule_parts: A list of rule parts to be grouped
  #
  # Returns:
  # A map where the keys are the blocks and the values are lists of statements
  defp gather_rule_parts(rule_parts) do
    rule_parts |> Enum.reduce([], fn rule_part, acc ->
      statement = get_statement(rule_part)
      block = String.to_atom(rule_part.block)
      case acc[block] do
        nil ->
          put_in(acc, [block], [statement])
        _ ->
          update_in(acc, [block], & &1 ++ [statement])
      end
    end)
  end

@doc """
  Retrieves and processes rule parts for a given rule ID.

  ## Parameters
  - `rule_id` - The ID of the rule to retrieve and process rule parts for.

  ## Returns
  A tuple containing the result of retrieving and processing the rule parts:
  - `:ok` - If the rule parts were successfully retrieved and processed.
  - `rule_parts` - The processed rule parts.

  ## Examples

      get_processed_rule_parts(123)

      # Output:
      # {:ok, [processed_rule_part1, processed_rule_part2, ...]}
  """
  def get_processed_rule_parts(rule_id) do
    {:ok, rule_parts} = list_rule_parts_by_rule_id(rule_id)
    rule_parts |> sort_and_gather()
  end

end
