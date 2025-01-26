defmodule Tpe.RulePart.Read do
  @moduledoc """
  This module provides functions for reading rule parts from the database.
  """

  use Ecto.Schema
  use Ecto.Repo, otp_app: :tpe, adapter: Ecto.Adapters.Postgres
  import Ecto.Query, only: [from: 2]
  import Wongi.Engine.DSL, only: [has: 4]

  @doc """
  Retrieves a rule part by its ID.

  ## Params:
    - id: The ID of the rule part to retrieve.

  ## Returns:
    A tuple containing the result of retrieving the rule part:
    - `:ok` - If the rule part was successfully retrieved.
    - `rule_part` - The retrieved rule part.
    - `:error` - If the rule part was not found.
    - `:rule_part_not_found` - If the rule part was not found.

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

  ## Params:
    - rule_id: The ID of the rule to retrieve rule parts for.
    - verb: The verb to filter the rule parts by. If not provided, all rule parts for the rule are retrieved.

  ## Returns:
    A tuple containing the result of retrieving the rule parts:
    - `:ok` - If the rule parts were successfully retrieved.
    - `rule_parts` - The retrieved rule parts.
    - `:error` - If the rule parts were not found.
    - `:rule_part_not_found` - If the rule parts were not found.

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
    rule_parts =
      case verb do
        nil ->
          Tpe.Repo.all(from(rp in Tpe.RulePart, where: rp.rule_id == ^rule_id))

        _ ->
          Tpe.Repo.all(
            from(rp in Tpe.RulePart, where: rp.rule_id == ^rule_id and rp.verb == ^verb)
          )
      end

    cond do
      rule_parts in [nil, []] ->
        {:error, :rule_part_not_found}

      true ->
        {:ok, rule_parts}
    end
  end

  # Sorts and gathers the given rule parts based on their order and verb.
  #
  # Params:
  # - rule_parts: A list of rule parts to be sorted and gathered.
  #  Returns:
  # A list of maps where the keys are the blocks and the values are lists of statements

  defp sort_and_gather(rule_parts) do
    rule_parts
    |> Enum.sort_by(&{&1.order, &1.verb})
  end

  # Processes the arguments and returns a map with atom keys and corresponding values.
  #
  # Params:
  #   - arguments: a list of key-value pairs
  #
  # Returns:
  #   - a map with atom keys and corresponding values
  defp process_arguments(arguments) do
    Enum.reduce(arguments, %{}, fn {key, value}, acc ->
      value =
        case is_binary(value) do
          true ->
            case key do
              "filter" ->
                Regex.replace(~r/var\((:.*)\)/U, value, "Wongi.Engine.DSL.var(\\1)")

              _ ->
                # if it is a simple var() string
                new_value = Regex.run(~r/var\(:(.*)\)/U, value, capture: :all_but_first)

                case new_value do
                  [var] -> %Wongi.Engine.DSL.Var{name: String.to_atom(var)}
                  _ -> String.to_atom(value)
                end
            end

          _ ->
            value
        end

      Map.put(acc, String.to_atom(key), value)
    end)
  end

  defp dune_filter(filter) do
    # Evaluates the given filter using Dune and returns the result.
    #
    # The `filter` parameter is a string representing the filter to be evaluated.
    #
    # If the evaluated result is a binary, it is further evaluated using Code and
    # the first element of the result is returned. Otherwise, the original filter
    # is returned.
    #
    # Examples:
    #
    #   iex> dune_filter("1 + 2")
    #   3
    #
    #   iex> dune_filter("foo")
    #   "foo"
    #
    # Returns the evaluated result or the original filter.
    dune_test =
      Dune.eval_string(to_string(filter), allowlist: Tpe.RulePart.DuneAllowlist, timeout: 100)

    if is_binary(dune_test.inspected) do
      Code.eval_string(to_string(filter)) |> elem(0)
    else
      filter
    end
  end

  # Retrieves the statement based on the given rule_part.
  #
  # Params:
  #   - rule_part: A map representing a rule part.
  #
  # Returns:
  #   The statement corresponding to the rule_part.
  #
  # Raises:
  #   - "Unknown verb" if the verb in the rule_part is not recognized.
  #
  # Examples:
  #   iex> rule_part = %{verb: "has", arguments: %{subject: "Alice", predicate: "likes", object: "Bob"}}
  #   iex> get_statement(rule_part)
  #   iex> has("Alice", "likes", "Bob")
  #
  defp get_statement(rule_part) do
    import Wongi.Engine.DSL
    arguments = Map.get(rule_part, :arguments)
    arguments = arguments |> process_arguments()
    verb = Map.get(rule_part, :verb)

    case verb do
      "has" ->
        case Map.get(arguments, :filter, nil) do
          nil ->
            has(arguments.subject, arguments.predicate, arguments.object)

          _ ->
            filter = dune_filter(arguments.filter)

            has(arguments.subject, arguments.predicate, arguments.object, when: filter)
        end

      "neg" ->
        neg(arguments.subject, arguments.predicate, arguments.object)

      "assign" ->
        eval = Map.get(arguments, :eval, nil)

        value =
          case to_string(eval) do
            # @TODO: This is a hack to get around a weird failure in the way I am using Dune and anonymous functions
            #
            # if value is something like Dune.eval_string("&(&1[:test_number] / 50)") it will fail with
            # ** (UndefinedFunctionError) Access.get/50 is undefined or private
            # I'm sure there is a solution out there, but for now
            # if you are finding this a problem, you can convert the denomenator to its inverse and multiply
            # e.g. 4 / 2 becomes 4 * 0.5
            # or use div(num*1000, den*1000) or similar

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
        raise RuntimeError, "Unknown verb"
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
    rule_parts
    |> Enum.reduce([], fn rule_part, acc ->
      statement = get_statement(rule_part)
      block = String.to_atom(rule_part.block)

      case acc[block] do
        nil ->
          put_in(acc, [block], [statement])

        _ ->
          update_in(acc, [block], &(&1 ++ [statement]))
      end
    end)
  end

  # Retrieves and processes rule parts for a given rule ID.
  #
  # ## Parameters
  # - `rule_id` - The ID of the rule to retrieve and process rule parts for.
  #
  # ## Returns
  # A tuple containing the result of retrieving and processing the rule parts:
  # - `:ok` - If the rule parts were successfully retrieved and processed.
  # - `rule_parts` - The processed rule parts.
  #
  # ## Examples
  #
  #     get_processed_rule_parts(123)
  #
  #     # Output:
  #     # {:ok, [processed_rule_part1, processed_rule_part2, ...]}
  #
  def get_processed_rule_parts(rule_id) do
    {:ok, rule_parts} = list_rule_parts_by_rule_id(rule_id)
    rule_parts |> sort_and_gather() |> gather_rule_parts()
  end
end
