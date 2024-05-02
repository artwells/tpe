defmodule Tpe.Rule do
  @moduledoc """
  This module defines the schema and changeset for the 'rule' table.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @doc """
  The schema for the 'rule' table.

  ## Fields

  - `name` (`string`): The name of the rule.
  - `description` (`string`): The description of the rule.
  - `type` (`string`, default: "basic"): The type of the rule.
  - `inserted_at` (`utc_datetime_usec`): The timestamp when the rule was inserted.
  - `updated_at` (`utc_datetime_usec`): The timestamp when the rule was last updated.
  """
  schema "rule" do
    field(:name, :string)
    field(:description, :string)
    field(:type, :string, default: "basic")
    field(:inserted_at, :utc_datetime_usec)
    field(:updated_at, :utc_datetime_usec)
    has_many(:rule_parts, Tpe.RulePart)
  end

  @doc """
  Builds and validates changesets for the 'rule' table.

  ## Params

  - `rule` (`Tpe.RulePart`): The rule struct.
  - `params` (`map`, default: `%{}`): The parameters to update the rule.

  ## Returns

  A changeset struct.

  ## Examples

      iex> changeset = Tpe.RulePart.changeset(rule, %{name: "New Rule", type: "advanced"})
      iex> changeset.valid?
      true
  """
  def changeset(rule, params \\ %{}) do
    rule
    |> cast(params, [:name, :description, :type, :updated_at])
    |> validate_required([:name, :type])
  end
end
