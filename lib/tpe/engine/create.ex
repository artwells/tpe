defmodule Tpe.Engine.Create do
  @moduledoc """
  This module provides functions for creating and populating engines in the Tpe application.
  """

  import Wongi.Engine
  import Wongi.Engine.DSL

  @doc """
  Creates a new engine instance and compiles and adds all valid rule parts to the engine.

  ## Examples

      iex> Tpe.Engine.Create.create_engine()
      %Wongi.Engine{...}
  """
  def create_engine() do
    engine = new()
    #collect all valid rule IDs and compile them into the engine
    Enum.reduce(Tpe.Rule.Read.get_all_valid_ids, engine, fn id, acc ->
      rule = Tpe.RulePart.Read.get_processed_rule_parts(id) |> rule()
      acc |> Wongi.Engine.compile(rule)
    end)
  end
end
