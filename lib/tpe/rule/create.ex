defmodule Tpe.Rule.Create do
  @moduledoc """
  This module provides functions for creating rules in the Tpe application.


  """

  use Ecto.Schema
  use Ecto.Repo, otp_app: :tpe, adapter: Ecto.Adapters.Postgres

  @doc """
  Creates a new rule with the given attributes.

  ## Examples

      iex> {:ok, rule} = Tpe.Rule.Create.create_rule(%{name: "Rule 1", description: "new test"})
      iex> rule.name
      "Rule 1"

  ## Params

  - `attrs` (optional) - A map containing the attributes for the rule.
    - `:name` (optional) - The name of the rule.
    - `:condition` (optional) - The condition of the rule.

  ## Returns

  A tuple with `:ok` and the created rule on success, or an error tuple otherwise.

  """
  def create_rule(attrs \\ %{}) do
    attrs = Map.put(attrs, :updated_at, DateTime.utc_now())

    rule =
      %Tpe.Rule{}
      |> Tpe.Rule.changeset(attrs)
      |> Tpe.Repo.insert()

    rule
  end
end
