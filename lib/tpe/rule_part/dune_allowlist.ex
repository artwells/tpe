defmodule Tpe.RulePart.DuneAllowlist do
  use Dune.Allowlist

  allow Wongi.Engine.DSL, :all
end
