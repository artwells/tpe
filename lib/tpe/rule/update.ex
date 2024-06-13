defmodule Tpe.Rule.Update do
  @moduledoc """
  This module provides functions for updating a rule in the Tpe application.
  """

  use Ecto.Schema
  use Ecto.Repo, otp_app: :my_app, adapter: Ecto.Adapters.Postgres

  @doc """
  Updates a rule with the given ID and attributes.

  ## Examples

    iex> attrs = %{name: "Test Rule", description: "Test Description", type: "basic"}
    iex>{:ok, rule} = Tpe.Rule.Create.create_rule(attrs)
    iex> attrs = %{name: "New Rule", description: "New Description"}
    iex> {:ok, _new_rule} = Tpe.Rule.Update.update_rule(rule.id, attrs)


  """
  def update_rule(id, attrs \\ %{}) do
    attrs = Map.put(attrs, :updated_at, DateTime.utc_now())
    rule = Tpe.Repo.get(Tpe.Rule, id)
    cond do
      rule == nil ->
        {:error, :rule_not_found}
      true ->
        rule
        |> Tpe.Rule.changeset(attrs)
        |> Tpe.Repo.update()
    end
  end
end
