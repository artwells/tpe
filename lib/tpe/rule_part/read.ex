defmodule Tpe.RulePart.Read do
  @moduledoc """
  This module provides functions for reading rule parts from the database.
  """

  use Ecto.Schema
  use Ecto.Repo, otp_app: :my_app, adapter: Ecto.Adapters.Postgres
  import Ecto.Query, only: [from: 2]

  @doc """
  Retrieves a rule part by its ID.

  ## Examples
  iex> attrs = %{rule_id: 9, block: "tester block", verb: "verb", arguments: %{}}
  iex> {:ok, rule_part1} = Create.create_rule_part(attrs)
  iex> rule_part1 = Tpe.RulePart.Read.get_rule_part(rule_part1.id)
  iex> rule_part1[:rule_id]
  9


  """
  def get_rule_part(id) do
    rule_part = Tpe.Repo.get(Tpe.RulePart, id)
    cond do
      rule_part == nil ->
        {:error, :rule_part_not_found}

      true ->
        {:ok, rule_part}
    end
  end

  @doc """
  Retrieves a list of rule parts by the rule ID.

  ## Examples
    iex> attrs = %{rule_id: 11, block: "tester block", verb: "verb", arguments: %{}}
    iex> {:ok, rule_part1} = Create.create_rule_part(attrs)
    iex> attrs = %{rule_id: 11, block: "tester block", verb: "verb", arguments: %{}}
    iex> {:ok, rule_part2} = Create.create_rule_part(attrs)
    iex> {:ok, [rule_part_1, rule_part_2]} = Tpe.RulePart.Read.list_rule_parts_by_rule_id(11)
    iex> rule_part_1.rule_id
    11

  """
  def list_rule_parts_by_rule_id(rule_id) do
    from(rp in Tpe.RulePart, where: rp.rule_id == ^rule_id, order_by: [asc: rp.id])
    |> Tpe.Repo.all()

    rule_parts = Tpe.Repo.all(from(rp in Tpe.RulePart, where: rp.rule_id == ^rule_id))

    cond do
      rule_parts in [nil, []] ->
        {:error, :rule_part_not_found}

      true ->
        {:ok, rule_parts}
    end
  end
end
