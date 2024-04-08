defmodule Tpe.RulePart.Delete do
  use Ecto.Schema
  use Ecto.Repo, otp_app: :my_app, adapter: Ecto.Adapters.Postgres
  import Ecto.Query, only: [from: 2]

  def delete_rule_part(id) do
    from(rp in Tpe.RulePart, where: rp.id == ^id)
    |> Repo.delete()
  end

  def delete_rule_parts_by_rule_id(rule_id) do
    from(rp in Tpe.RulePart, where: rp.rule_id == ^rule_id)
    |> Repo.delete_all()
  end

end
