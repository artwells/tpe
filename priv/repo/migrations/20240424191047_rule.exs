defmodule Tpe.Repo.Migrations.Rule do
  use Ecto.Migration

  def up do
    create table(:rule) do
      add :name, :string, null: false
      add :description, :string
      add :type, :string, null: false, default: "basic"
      timestamps(type: :timestamptz, default: fragment("now()"))
    end
    alter table(:rule_parts) do
      modify :rule_id, references(:rule, on_delete: :delete_all), null: true
    end
  end

  def down do
    drop constraint(:rule_parts, "rule_parts_rule_id_fkey")

    drop table(:rule)
  end
end
