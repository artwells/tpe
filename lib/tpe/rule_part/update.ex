defmodule Tpe.RulePart.Update do
  @moduledoc """
  This module provides functions for updating a rule part in the Tpe application.
"""

  use Ecto.Schema
  use Ecto.Repo, otp_app: :my_app, adapter: Ecto.Adapters.Postgres


  @doc """
  Updates a rule part with the given ID and attributes.

  ## Parameters

  * `id` - The ID of the rule part to update.
  * `attrs` - A map of attributes to update.

  ## Examples
    iex> attrs = %{rule_id: 11, block: "tester block", verb: "verb", arguments: %{}}
    iex> {:ok, rule_part1} = Create.create_rule_part(attrs)
    iex> updated_attrs = %{block: "updated block", verb: "updated verb"}
    iex> {:ok, updated_rule_part} = Update.update_rule_part(rule_part1.id, updated_attrs)
    iex> updated_rule = Tpe.RulePart.Read.get_rule_part(rule_part1.id)
    iex> updated_rule.verb
    "updated verb"

  ## Returns

  Returns the updated rule part on success, or an error tuple on failure.

  """
  def update_rule_part(id, attrs \\ %{}) do
    attrs = Map.put(attrs, :updated_at, DateTime.utc_now())
    rule_part = Tpe.Repo.get(Tpe.RulePart, id)
    cond do
      rule_part == nil ->
        {:error, :rule_part_not_found}
      true ->
        rule_part
        |> Tpe.RulePart.changeset(attrs)
        |> Tpe.Repo.update()
    end
  end
end
