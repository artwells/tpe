
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

  #create a changeset
  @spec changeset(
          {map(), map()}
          | %{
              :__struct__ => atom() | %{:__changeset__ => map(), optional(any()) => any()},
              optional(atom()) => any()
            }
        ) :: Ecto.Changeset.t()
  def changeset(coupon, params \\ %{}) do
    coupon
    |> cast(params, [:code, :active, :count, :promo_id, :inserted_at, :updated_at])
    |> validate_required([:code, :promo_id])
  end

  #create a new coupon
  def create_coupon(attrs \\ %{}) do
    # add current datetime to inserted_at and updated_at
    IO.puts("attrs: #{inspect(attrs)}")
    %Low.Coupon{}
    |> Low.Coupon.changeset(attrs)
    |> Low.Repo.insert()
  end


  #increment the count of a coupon

  def increment_count(coupon) do
    coupon
    |> Ecto.Changeset.change(count: coupon.count + 1)
    |> Low.Repo.update()
  end

  #change a coupon
  def change_coupon(coupon, attrs \\ %{}) do
    attrs = Map.put(attrs, :updated_at, DateTime.utc_now())
    coupon
    |> Low.Coupon.changeset(attrs)
    |> Low.Repo.update()
  end

  def get_coupon(id) do
    Low.Repo.get(Low.Coupon, id)
  end

   def get_coupon_by_code(code) do
    Low.Repo.get_by(Low.Coupon, code: code)
   end


  end
