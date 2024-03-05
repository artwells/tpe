defmodule Low.Repo.Migrations.CreateLow do
  use Ecto.Migration

  def change do
    create table(:coupons) do
      add :code, :string, unique: true, null: false
      add :active, :boolean, default: false
      add :count, :integer, default: 0, null: false
      add :promo_id, :integer, null: false
      timestamps(opts)
    end

    create index(:coupons, [:code, :active], unique: true)
    create index(:coupons, [:promo_id], unique: false)
  end
end
