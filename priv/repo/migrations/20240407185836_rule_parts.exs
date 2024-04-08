defmodule Tpe.Repo.Migrations.RuleParts do
  use Ecto.Migration
  def change do
    create table(:rule_parts) do
      add :rule_id, :integer, null: false
      add :block, :string, null: false
      add :verb, :string, null: false
      add :arguments, :map, null: false
      timestamps(type: :timestamptz, default: fragment("now()"))
    end
    create index(:rule_parts, [:rule_id])
  end
end
