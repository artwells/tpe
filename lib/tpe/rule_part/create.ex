defmodule Tpe.RulePart.Create do
  @moduledoc """
  This module provides functions for creating rule parts in the Tpe application.

  """

  use Ecto.Schema
  use Ecto.Repo, otp_app: :my_app, adapter: Ecto.Adapters.Postgres

  @spec create_rule_part() :: {:ok, any()}
  @doc """
  Creates a new rule part with the given attributes.

  ## Examples

  iex>   {:ok, rp} = Tpe.RulePart.Create.create_rule_part(%{rule_id: 8, block: "block", verb: "verb", arguments: %{}})
  iex> part = Map.from_struct(rp)
  iex> part.rule_id
  8

  """
  def create_rule_part(attrs \\ %{}) do
    attrs = Map.put(attrs, :updated_at, DateTime.utc_now())

    rule_part = %Tpe.RulePart{}
    |> Tpe.RulePart.changeset(attrs)
    |> Tpe.Repo.insert()
    rule_part
  end
end
