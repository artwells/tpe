defmodule Tpe.CoupTest.Create do
  use ExUnit.Case, async: true
  use Ecto.Repo, otp_app: :my_app, adapter: Ecto.Adapters.Postgres
  alias Tpe.TestTools
  alias Tpe.Coupon
  doctest Tpe.Coupon.Create, import: true

  setup do
    TestTools.sandbox_connection()
    :ok
  end

  test "create_coupon/1 creates a new coupon" do
    attrs = %{code: "DEF4056", active: true, count: 5, promo_id: 2}
    {:ok, coupon} = Coupon.Create.create_coupon(attrs)

    assert %Tpe.Coupon{} = coupon
    assert "DEF4056" == coupon.code
    assert true == coupon.active
    assert 5 == coupon.count
    assert 2 == coupon.promo_id
  end

  test "mass_create/4 generates random codes and inserts them in chunks" do
    count = 1
    promo_id = 3
    chunk_size = 10
    max_use = 5
    {:ok, success_count} = Coupon.Create.mass_create(count, promo_id, chunk_size, max_use)
    # confirm that the count of coupons for the promo is equal to the count
    assert success_count == count

    # check one coupon from the promo
    coupon = Enum.at(Coupon.Read.dump_coupons_by_promo_id(promo_id), 0)
    # check that the code is the correct length from config
    assert String.length(coupon.code) == Application.fetch_env!(:tpe, :code_length)
    # check that inserted_at and updated_at are the same and not null
    assert coupon.inserted_at == coupon.updated_at
    assert coupon.inserted_at != nil
  end

  test "mass_create/4 generates random codes and inserts them in chunks, with prefix and suffix" do
    count = 1
    promo_id = 3
    chunk_size = 10
    max_use = 5
    prefix = "PREFIX"
    suffix = "SUFFIX"

    {:ok, success_count} =
      Coupon.Create.mass_create(count, promo_id, chunk_size, max_use, prefix, suffix)

    # confirm that the count of coupons for the promo is equal to the count
    assert success_count == count

    assert Enum.all?(
      Coupon.Read.dump_coupons_by_promo_id(promo_id),
      # check each coupon with check_prefix_suffix
      fn coupon ->
        check_prefix_suffix(coupon, prefix, suffix)
      end
    )
  end

  defp check_prefix_suffix(coupon, prefix, suffix) do
    # remove prefix and suffix from code
    code = String.replace(coupon.code, prefix, "")
    code = String.replace(code, suffix, "")
    # ensure code length is shorter than coupon.code and that the combined are the same
    String.length(code) < String.length(coupon.code) &&
      coupon.code == "#{prefix}#{code}#{suffix}"
  end

  test "insert_coupons/1 inserts a list of coupons" do
    coupons = [
      %{code: "ABC8123", active: true, count: 10, promo_id: 1},
      %{code: "DEF8456", active: true, count: 5, promo_id: 2}
    ]

    {:ok, success_count} = Coupon.Create.insert_coupons(coupons)
    assert success_count == {2, nil}
    {:ok, retrieved_coupon} =  Coupon.Read.get_coupon_by_code("ABC8123")
    assert %Tpe.Coupon{} = retrieved_coupon
    assert "ABC8123" == retrieved_coupon.code
    assert true == retrieved_coupon.active
    {:ok, retrieved_coupon} =  Coupon.Read.get_coupon_by_code("DEF8456")
    assert %Tpe.Coupon{} = retrieved_coupon
    assert "DEF8456" == retrieved_coupon.code
    assert true == retrieved_coupon.active
  end

  test "insert_coupons_from_csv/1 inserts coupons from a CSV file" do
    file_path = "test/fixtures/coupons_with_promo_id.csv"
    {:ok, 2_000} = Coupon.Create.insert_coupons_from_csv(file_path)

    # Assert that the coupons are inserted correctly
    assert {:ok, coupon1} = Coupon.Read.get_coupon_by_code("RPCXAF47HWLQYKM6BV9NDTJ8")
    assert %Coupon{code: "RPCXAF47HWLQYKM6BV9NDTJ8", promo_id: 28} = coupon1
    assert {:ok, coupon2} = Coupon.Read.get_coupon_by_code("43XYNM7AE86HGVQWKUJTCLPF")
    assert %Coupon{code: "43XYNM7AE86HGVQWKUJTCLPF", promo_id: 21} = coupon2
  end

  test "insert_coupons_from_csv_fixed_promo_id/2 inserts coupons from a CSV file with a fixed promo_id" do
    file_path = "test/fixtures/coupons.csv"
    promo_id = 17
    {:ok, 2_000} = Coupon.Create.insert_coupons_from_csv_fixed_promo_id(file_path, promo_id)

    # Assert that the coupons are inserted correctly
    assert {:ok, coupon1} = Coupon.Read.get_coupon_by_code("FYGEP4VXA9KBJDQHL7RTW8M6")
    assert %Coupon{code: "FYGEP4VXA9KBJDQHL7RTW8M6", promo_id: 17} = coupon1
    assert {:ok, coupon2} = Coupon.Read.get_coupon_by_code("JEBG6DXRQ9AFCU3LV4YNPWKH")
    assert %Coupon{code: "JEBG6DXRQ9AFCU3LV4YNPWKH", promo_id: 17} = coupon2
  end
end
