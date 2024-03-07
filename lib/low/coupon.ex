defmodule Low.Coupon do
  use Ecto.Schema
  use Ecto.Repo, otp_app: :my_app, adapter: Ecto.Adapters.Postgres

  import Ecto.Changeset

  schema "coupons" do
    field :code, :string
    field :active, :boolean
    field :count, :integer
    field :max_count, :integer
    field :promo_id, :integer
    field :inserted_at, :utc_datetime
    field :updated_at, :utc_datetime
  end

  # Create a changeset

  def changeset(coupon, params \\ %{}) do
    coupon
    |> cast(params, [:code, :active, :count, :max_count, :promo_id, :updated_at])
    |> validate_required([:code, :promo_id])
  end

  # Create a new coupon
  def create_coupon(attrs \\ %{}) do
    %Low.Coupon{}
    |> Low.Coupon.changeset(attrs)
    |> Low.Repo.insert()
  end

  # Increment the count of a coupon
  def increment_count(coupon) do
    coupon
    |> Ecto.Changeset.change(count: coupon.count + 1)
    |> Low.Repo.update()
  end

  # Change a coupon
  def change_coupon(coupon, attrs \\ %{}) do
   attrs = Map.put(attrs, :updated_at, DateTime.utc_now())
    coupon
    |> Low.Coupon.changeset(attrs)
    |> Low.Repo.update()
  end

  def get_coupon(id) do
    coupon = Low.Repo.get(Low.Coupon, id)
    cond do
      coupon == nil ->
        {:error, :coupon_not_found}
      true ->
        {:ok, coupon}
    end
  end

  def get_coupon_by_code(code) do
    coupon = Low.Repo.get_by(Low.Coupon, code: code)
    #return error if coupon not found
    cond do
      coupon == nil ->
        {:error, :coupon_not_found}
      true ->
        {:ok, coupon}
    end
  end

  # Get coupon by code checking to see that count is not greater than max_count
  def get_valid_coupon(code) do
    case get_coupon_by_code(code)
    do
      {:ok, coupon} ->
        cond do
        coupon.active != :true ->
          {:error, :coupon_not_active}
        coupon.count >= coupon.max_count ->
          {:error, :coupon_count_greater_than_max_count}
        true ->
          {:ok, coupon}
      end
      {:error, error} ->
        {:error, error}
    end
  end

  # insert a map of coupons
  def insert_coupons(coupons) do
    Low.Repo.insert_all(Low.Coupon, coupons, on_conflict: :nothing)
  end
end
