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
end
