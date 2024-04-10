defmodule Tpe.RulePart.Delete do
  @moduledoc """
  This module provides functions for deleting rule parts from the database.
  """
  import Ecto.Query, only: [from: 2]

  @doc """
  Deletes a rule part with the given ID from the database.

  ## Examples
      iex> attrs = %{rule_id: 8, block: "tester block", verb: "verb", arguments: %{}}
      iex>{:ok, rule_part} = Tpe.RulePart.Create.create_rule_part(attrs)
      iex> {:ok, _} = Tpe.RulePart.Delete.delete_rule_part(rule_part.id)

  """
def delete_rule_part(id) do
  rule_part = Tpe.Repo.get(Tpe.RulePart, id)

  case rule_part do
    nil -> {:error, "Rule part not found"}
    _ -> Tpe.Repo.delete(rule_part)
  end

end

  @doc """
  Deletes all rule parts associated with a given rule ID from the database.

  ## Examples

      iex> attrs = %{rule_id: 7, block: "tester block", verb: "verb", arguments: %{}}
      iex>{:ok, _} = Tpe.RulePart.Create.create_rule_part(attrs)
      iex> Tpe.RulePart.Delete.delete_rule_parts_by_rule_id(7)
      {1, nil}

  """
  def delete_rule_parts_by_rule_id(rule_id) do
    from(rp in Tpe.RulePart, where: rp.rule_id == ^rule_id)
    |> Tpe.Repo.delete_all()
  end

end
