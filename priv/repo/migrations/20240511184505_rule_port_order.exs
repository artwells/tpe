defmodule Tpe.Repo.Migrations.RulePortOrder do
  use Ecto.Migration

  def change do
    alter table(:rule_parts) do
      add :order, :integer, null: false, default: 0
    end
  end
end
