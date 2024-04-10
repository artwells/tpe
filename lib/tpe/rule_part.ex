defmodule Tpe.RulePart do
  @moduledoc """
  This module defines the `Tpe.RulePart` schema and changeset.

  The `Tpe.RulePart` schema represents a rule part record in the database.
  It defines the fields and their types for a rule part.

  ## Fields

  - `id` (`integer`): The ID of the rule part.
  - `rule_id` (`integer`): The ID of the associated rule.
  - `block` (`string`): The block of the rule part.
  - `verb` (`string`): The verb of the rule part.
  - `arguments` (`map`): The arguments of the rule part.
  - `inserted_at` (`utc_datetime`): The timestamp when the rule part was inserted.
  - `updated_at` (`utc_datetime`): The timestamp when the rule part was last updated.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "rule_parts" do
    field(:rule_id, :integer)
    field(:block, :string)
    field(:verb, :string)
    field(:arguments, :map)
    field(:inserted_at, :utc_datetime_usec)
    field(:updated_at, :utc_datetime_usec)
  end

  def changeset(rule_part, params \\ %{}) do
    rule_part
    |> cast(params, [:rule_id, :block, :verb, :arguments, :updated_at])
    |> validate_required([:rule_id, :block, :verb, :arguments])
  end
end
