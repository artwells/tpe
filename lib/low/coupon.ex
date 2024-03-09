defmodule Low.Coupon do

  use Ecto.Schema
  use Ecto.Repo, otp_app: :my_app, adapter: Ecto.Adapters.Postgres

  import Ecto.Changeset

  @insert_all_timeout 600000


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
    Low.Repo.transaction(fn ->
      Low.Repo.insert_all(Low.Coupon, coupons, on_conflict: :nothing)

    end, timeout: @insert_all_timeout) # Set the timeout value in milliseconds

  end
  def fulfill_count(count, promo_id) do
    codes = generate_random_codes(count, promo_id)
    success_count = Enum.reduce(chunk(codes, 10), 0, fn chunk, acc ->
      {:ok, {count, _}} = Low.Coupon.insert_coupons(chunk)
      count + acc
    end)
    #recurse if not all codes were inserted
    if success_count < count do
      fulfill_count(count - success_count, promo_id)
    end
    {:ok, success_count}

  end


  defp generate_random_codes(count, promo_id) do
    Enum.map(1..count, fn _ ->
      %{code: :crypto.strong_rand_bytes(3) |> Base.encode64(), promo_id: promo_id}
    end)
  end



  defp chunk(list, size) when is_list(list) and is_integer(size) and size > 0 do
    Enum.chunk_every(list, size)
  end
end
