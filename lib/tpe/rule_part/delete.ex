defmodule Tpe.RulePart.Delete do
  @moduledoc """
  This module provides functions for deleting rule parts from the database.
  """

  use Ecto.Schema
  use Ecto.Repo, otp_app: :my_app, adapter: Ecto.Adapters.Postgres
  import Ecto.Query, only: [from: 2]

  @doc """
  Deletes a rule part with the given ID from the database.

  ## Examples

      iex> Tpe.RulePart.Delete.delete_rule_part(1)
      :ok

  """
  def delete_rule_part(id) do
    from(rp in Tpe.RulePart, where: rp.id == ^id)
    |> Tpe.Repo.delete()
  end

  @doc """
  Deletes all rule parts associated with a given rule ID from the database.

  ## Examples

      iex> Tpe.RulePart.Delete.delete_rule_parts_by_rule_id(1)
      :ok

  """
  def delete_rule_parts_by_rule_id(rule_id) do
    from(rp in Tpe.RulePart, where: rp.rule_id == ^rule_id)
    |> Tpe.Repo.delete_all()
  end

end
