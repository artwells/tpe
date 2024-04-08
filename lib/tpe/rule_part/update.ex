defmodule Tpe.RulePart.Update do
  use Ecto.Schema
  use Ecto.Repo, otp_app: :my_app, adapter: Ecto.Adapters.Postgres

  def update_rule_part(id, params) do
    from(rp in Tpe.RulePart, where: rp.id == ^id)
    |> Repo.get()
    |> case do
      nil -> {:error, "Rule part not found"}
      rule_part ->
        rule_part
        |> Tpe.RulePart.changeset(params)
        |> Repo.update()
    end
  end

end
