defmodule Tpe.Engine.Update do
  @moduledoc """
  This module provides functions for interacting with engines in the Tpe application.
  """

  import Wongi.Engine

  @doc """
  Asserts a list of Working Memory Elements (WMEs) in the engine.

  ## Examples

      engine = Wongi.Engine.create_engine()
      wmes = [
        { :fact, :is, 42 },
        { :fact, :has, "GitHub Copilot" }
      ]
      Tpe.Engine.Update.assert_wmes(engine, wmes)

  """
  def assert_wmes(engine, wmes) do
    Enum.reduce(wmes, engine, fn wme, acc ->
      acc |> assert(wme)
    end)
  end
end
