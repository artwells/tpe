defmodule Tpe.RulePart.Read do
  use Ecto.Schema
  use Ecto.Repo, otp_app: :my_app, adapter: Ecto.Adapters.Postgres

  def create_rule_part(rule_id, block, verb, arguments) do
    %Tpe.RulePart{}
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put(:rule_id, rule_id)
    |> Ecto.Changeset.put(:block, block)
    |> Ecto.Changeset.put(:verb, verb)
    |> Ecto.Changeset.put(:arguments, arguments)
    |> Repo.insert()
  end

end
