defmodule Tpe.Rule.Read do
  @moduledoc """
  This module provides functions for reading rule parts from the database.
  """

  use Ecto.Schema
  use Ecto.Repo, otp_app: :my_app, adapter: Ecto.Adapters.Postgres


  @doc """
  Retrieves a rule part by its ID.

  ## Examples
  iex> attrs = %{name: "test rule", description: "test description"}
  iex> {:ok, rule} = Create.create_rule(attrs)
  iex> {:ok, rule1} = Tpe.Rule.Read.get_rule(rule.id)
  iex> rule1.name
  "test rule"
  """
  def get_rule(id) do
    rule = Tpe.Repo.get(Tpe.Rule, id)
    cond do
      rule == nil ->
        {:error, :rule_not_found}

      true ->
        {:ok, rule}
    end
  end
  @doc """
    Retrieves a rule and its associated rule parts by the given ID.

    ## Examples
        iex> attrs = %{name: "test rule", description: "test description"}
        iex> {:ok, rule} = Create.create_rule(attrs)
        iex> {:ok, new_rule} = Tpe.Rule.Read.get_rule_and_rule_parts(rule.id)
        iex> new_rule.rule.name
        "test rule"

        iex> Tpe.Rule.Read.get_rule_and_rule_parts(0)
        {:error, :rule_not_found}

    ## Params

    - `id` - The ID of the rule to retrieve.

    ## Returns

    - `{:ok, %{rule: rule, rule_parts: rule_parts}}` - If the rule and rule parts are found, returns a tuple with `:ok` and a map containing the rule and rule parts.
    - `{:error, :rule_not_found}` - If the rule is not found, returns a tuple with `:error` and `:rule_not_found`.
    - `{:error, :rule_part_not_found}` - If the rule parts are not found, returns a tuple with `:error` and `:rule_part_not_found`.
    """
    def get_rule_and_rule_parts(id) do
      rule = Tpe.Repo.get(Tpe.Rule, id)
      rule_parts = Tpe.RulePart.Read.list_rule_parts_by_rule_id(id)
      rule_parts = cond do
        rule_parts == {:error, :rule_part_not_found} ->
            []
          true ->
            rule_parts
        end
      cond do
        rule == nil ->
          {:error, :rule_not_found}
        true ->
          {:ok, %{rule: rule, rule_parts: rule_parts}}
      end
    end

end
