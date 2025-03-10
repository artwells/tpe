defmodule Tpe.Repo.Migrations.CreateTpe do
  use Ecto.Migration

  def change do
    create table(:coupons) do
      add :code, :string, unique: true, null: false
      add :active, :boolean, default: true
      add :count, :integer, default: 0, null: false
      add :max_use, :integer, default: 1, null: false
      add :promo_id, :integer, null: false
      timestamps(type: :timestamptz, default: fragment("now()"))
    end

    create index(:coupons, [:code], unique: true)
    create index(:coupons, [:promo_id], unique: false)
  end
end
