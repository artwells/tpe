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

end
