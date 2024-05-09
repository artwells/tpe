defmodule Tpe.RulePart.Read do
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
  def list_rule_parts_by_rule_id(rule_id) do
    rule_parts = Tpe.Repo.all(from(rp in Tpe.RulePart, where: rp.rule_id == ^rule_id))

    cond do
      rule_parts in [nil, []] ->
        {:error, :rule_part_not_found}

      true ->
        {:ok, rule_parts}
    end
  end

  # Sorts the given list of rule parts based on a specific order.
  #
  # The rule parts are sorted in the following order:
  #   - Rule parts with the verb "has" come first.
  #   - Rule parts with the verb "assign" come second.
  #   - Rule parts with the block "do" come last.
  #
  # Examples:
  #
  #   sort_rule_parts([
  #     %{verb: "assign"},
  #     %{verb: "has"},
  #     %{block: "do"}
  #   ])
  #   # => [
  #   #      %{verb: "has"},
  #   #      %{verb: "assign"},
  #   #      %{block: "do"}
  #   #    ]
  #
  defp sort_rule_parts(rule_parts) do
    rule_parts |> Enum.sort_by(fn
      %{verb: "has"} -> 0
      %{verb: "assign"} -> 1
      %{block: "do"} -> 2
    end)
  end

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

  defp get_statement(rule_part) do
    import Wongi.Engine.DSL
    arguments = Map.get(rule_part, :arguments)
    arguments = arguments |> process_arguments()

    verb = Map.get(rule_part, :verb)

    case verb do
      "has" ->
        has(arguments.subject, arguments.predicate, arguments.object)

      "assign" ->
        value =
          case to_string(arguments.eval) do
            "dune" ->
              dune_test = Dune.eval_string(to_string(arguments.value))
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

  def get_processed_rule_parts(rule_id) do
    {:ok, rule_parts} = list_rule_parts_by_rule_id(rule_id)
    rule_parts |> sort_rule_parts() |> gather_rule_parts()
  end
end
