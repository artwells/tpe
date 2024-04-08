defmodule Tpe.RulePart.Create do
  @moduledoc """
  This module provides functions for creating rule parts in the Tpe application.

  The `create_rule_part/1` function creates a new rule part with the given attributes.

  ## Examples

  iex> Tpe.RulePart.Create.create_rule_part(%{name: "Rule Part 1"})
  {:ok, %Tpe.RulePart{}}

  """

  use Ecto.Schema
  use Ecto.Repo, otp_app: :my_app, adapter: Ecto.Adapters.Postgres

  @doc """
  Creates a new rule part with the given attributes.

  ## Examples

  iex> Tpe.RulePart.Create.create_rule_part(%{name: "Rule Part 1"})
  {:ok, %Tpe.RulePart{}}

  """
  def create_rule_part(attrs \\ %{}) do
    attrs = Map.put(attrs, :updated_at, DateTime.utc_now())

    %Tpe.RulePart{}
    |> Tpe.RulePart.changeset(attrs)
    |> Tpe.Repo.insert()
  end
end
