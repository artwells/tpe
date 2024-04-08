defmodule Tpe.RulePart.Read do
  use Ecto.Schema
  use Ecto.Repo, otp_app: :my_app, adapter: Ecto.Adapters.Postgres
  import Ecto.Query, only: [from: 2]

  def get_rule_part(id) do
    from(rp in Tpe.RulePart, where: rp.id == ^id)
    |> Repo.one()
  end

  def list_rule_parts do
    from(rp in Tpe.RulePart, order_by: [asc: rp.id])
    |> Repo.all()
  end

  def list_rule_parts_by_rule_id(rule_id) do
    from(rp in Tpe.RulePart, where: rp.rule_id == ^rule_id, order_by: [asc: rp.id])
    |> Repo.all()
  end

end
