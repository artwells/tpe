defmodule Tpe.Engine.Create do
  @moduledoc """
  This module provides functions for creating and populating engines in the Tpe application.

  """
  import Wongi.Engine
  import Wongi.Engine.DSL

  def create_engine() do
    engine = new()
    Enum.reduce(Tpe.Rule.Read.get_all_valid_ids, engine, fn id, acc ->
      rule = Tpe.RulePart.Read.get_processed_rule_parts(id) |> rule()
      acc |> Wongi.Engine.compile(rule)
    end)
  end
end
