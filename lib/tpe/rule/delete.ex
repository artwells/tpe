defmodule Tpe.Rule.Delete do
  @moduledoc """
  This module provides functions for deleting rules from the database.
  """

  @doc """
  Deletes a rule with the given ID from the database.

  ## Examples
  iex> attrs = %{name: "Test Rule", description: "Test Description", type: "basic"}
  iex>{:ok, rule} = Tpe.Rule.Create.create_rule(attrs)
  iex> {:ok, _} = Tpe.Rule.Delete.delete_rule(rule.id)
  """
  def delete_rule(id) do
    rule = Tpe.Repo.get(Tpe.Rule, id)

    case rule do
      nil -> {:error, "Rule not found"}
      _ -> Tpe.Repo.delete(rule)
    end
  end
end
