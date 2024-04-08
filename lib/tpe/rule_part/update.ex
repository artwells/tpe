defmodule Tpe.RulePart.Update do
  @moduledoc """
  This module provides functions for updating a rule part in the Tpe application.

  ## Examples

  iex> Tpe.RulePart.Update.update_rule_part(1, %{name: "New Rule Part"})
  %Tpe.RulePart{...}

  """

  use Ecto.Schema
  use Ecto.Repo, otp_app: :my_app, adapter: Ecto.Adapters.Postgres

  @doc """
  Updates a rule part with the given ID and attributes.

  ## Parameters

  * `id` - The ID of the rule part to update.
  * `attrs` - A map of attributes to update.

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
