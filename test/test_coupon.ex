defmodule Tpe.CouponTest do
  use ExUnit.Case
  use Ecto.Repo, otp_app: :my_app, adapter: Ecto.Adapters.Postgres
  alias Tpe.Coupon

  setup do
    :ok
  end

  def cleanup do
    Ecto.Adapters.SQL.query!(Tpe.Repo, "DELETE FROM coupons WHERE promo_id < 100")
  end

  test "changeset/2 casts and validates the coupon changeset" do
    changeset = Coupon.changeset(%Coupon{}, %{code: "ABC123", active: true, count: 10, promo_id: 1})

    assert changeset.valid?
    assert %{code: "ABC123", active: true, count: 10, promo_id: 1} == changeset.changes
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

  test "increment_use/1 increments the count of a coupon" do
    coupon = %{code: "ABC1238", active: true, count: 10, promo_id: 1}
    {:ok, coupon} = Coupon.Create.create_coupon(coupon)
    {:ok, updated_coupon} = Coupon.Update.increment_use(coupon)

    assert %Tpe.Coupon{} = updated_coupon
    assert 11 == updated_coupon.count
  end

  test "update_coupon/2 changes the attributes of a coupon" do
    cleanup()
    coupon = %{code: "ABC1239", active: true, count: 10, promo_id: 1}
    {:ok, coupon} = Coupon.Create.create_coupon(coupon)
    attrs = %{code: "DEF456", active: false, count: 5, promo_id: 2}
    {:ok, updated_coupon} = Coupon.Update.update_coupon(coupon, attrs)

    assert %Tpe.Coupon{} = updated_coupon
    assert "DEF456" == updated_coupon.code
    assert false == updated_coupon.active
    assert 5 == updated_coupon.count
    assert 2 == updated_coupon.promo_id
  end

  test "get_coupon/1 retrieves a coupon by id" do
    {:ok, coupon} = Coupon.Create.create_coupon(%{code: "ABC1235", active: true, count: 10, promo_id: 1})
    {:ok, retrieved_coupon} = Coupon.Read.get_coupon(coupon.id)

    assert %Tpe.Coupon{} = retrieved_coupon
    assert "ABC1235" == retrieved_coupon.code
    assert true == retrieved_coupon.active
    assert 10 == retrieved_coupon.count
    assert 1 == retrieved_coupon.promo_id
  end

  test "get_coupon_by_code/1 retrieves a coupon by code" do
    Coupon.Create.create_coupon(%{code: "ABC1236", active: true, count: 10, promo_id: 1})

    {:error, error} = Coupon.Read.get_coupon_by_code("ABC1236NOTACOUPON")
    assert :coupon_not_found == error
    {:ok, retrieved_coupon} = Coupon.Read.get_coupon_by_code("ABC1236")
    assert %Tpe.Coupon{} = retrieved_coupon
    assert "ABC1236" == retrieved_coupon.code
    assert true == retrieved_coupon.active
    assert 10 == retrieved_coupon.count
    assert 1 == retrieved_coupon.promo_id

    # test that coupon is still retrieved if dashes are included
    {:ok, retrieved_coupon} = Coupon.Read.get_coupon_by_code("ABC-1236")
    assert %Tpe.Coupon{} = retrieved_coupon
    assert "ABC1236" == retrieved_coupon.code
  end

  test "get_valid_coupon/1 retrieves active coupon by code and count" do
    {:ok, _coupon} = Coupon.Create.create_coupon(%{code: "ABC12307", active: true, count: 5, max_use: 6, promo_id: 1})

    {:error, error} = Coupon.Read.get_valid_coupon("ABC1236NOTACOUPON")
    assert :coupon_not_found == error

    {:ok, retrieved_coupon} = Coupon.Read.get_valid_coupon("ABC12307")
    assert %Tpe.Coupon{} = retrieved_coupon
    assert "ABC12307" == retrieved_coupon.code
    assert true == retrieved_coupon.active
    assert 5 == retrieved_coupon.count
    assert 1 == retrieved_coupon.promo_id

    {:ok, _updated_coupon} = Coupon.Update.update_coupon(retrieved_coupon, %{active: false})
    {:error, error} = Coupon.Read.get_valid_coupon("ABC12307")
    assert :coupon_not_active == error
    {:ok, retrieved_coupon} = Coupon.Read.get_coupon_by_code("ABC12307")
    {:ok, _updated_coupon} = Coupon.Update.update_coupon(retrieved_coupon, %{active: true})
    # increase count to 11 and test for error
    {:ok, _updated_coupon} = Coupon.Update.increment_use(retrieved_coupon)
    {:error, error} = Coupon.Read.get_valid_coupon("ABC12307")
    assert :coupon_count_greater_than_max_use == error
    # check that if the max_use is zero, no coupon_counter_greater_than_max_use error is returned
    {:ok, _updated_coupon} = Coupon.Update.update_coupon(retrieved_coupon, %{max_use: 0})
    {:ok, infinite_coupon} = Coupon.Read.get_valid_coupon("ABC12307")
    assert "ABC12307" = infinite_coupon.code

  end

  # test that checks that updated_at is updated when a coupon is changed and inserted_at is unchanged
  test "updated_at is updated when a coupon is changed" do
    {:ok, coupon} = Coupon.Create.create_coupon(%{code: "ABC12390", active: true, count: 10, promo_id: 1})
    updated_at = coupon.updated_at
    inserted_at = coupon.inserted_at
    Process.sleep(1000)
    {:ok, updated_coupon} = Coupon.Update.update_coupon(coupon, %{count: 7, promo_id: 2})
    assert updated_at < updated_coupon.updated_at
    assert inserted_at == updated_coupon.inserted_at
  end

  test "mass_create/4 generates random codes and inserts them in chunks" do
    cleanup()
    count = 1
    promo_id = 3
    chunk_size = 10
    max_use = 5

    {:ok, success_count} = Coupon.Create.mass_create(count, promo_id, chunk_size, max_use)
    # confirm that the count of coupons for the promo is equal to the count
    assert success_count == count

    #check one coupon from the promo
    coupon = Enum.at(Coupon.Read.dump_coupons_by_promo_id(promo_id), 0)
    #check that the code is the correct length from config

    assert String.length(coupon.code) == Application.fetch_env!(:tpe, :code_length)
    #check that inserted_at and updated_at are the same and not null
    assert coupon.inserted_at == coupon.updated_at
    assert coupon.inserted_at != nil



    cleanup()
    {:ok, success_count} = Coupon.Create.mass_create(count, promo_id, chunk_size, max_use, "PREFIX", "SUFFIX")
    # confirm that the count of coupons for the promo is equal to the count
    assert success_count == count
    assert Enum.all?(Coupon.Read.dump_coupons_by_promo_id(promo_id),
      #check each coupon with check_prefix_suffix
      fn coupon ->
      check_prefix_suffix(coupon, "PREFIX", "SUFFIX")
      end
    )
  end

  defp check_prefix_suffix(coupon, prefix, suffix) do
    #remove prefix and suffix from code
    code = String.replace(coupon.code, prefix, "")
    code = String.replace(code, suffix, "")
    #ensure code length is shorter than coupon.code and that the combined are the same
    String.length(code) < String.length(coupon.code) &&
    coupon.code == "#{prefix}#{code}#{suffix}"
  end

  test "dump_coupons_by_promo_id/1 retrieves all coupons associated with a given promo_id" do
    {:ok, coupon1} = Coupon.Create.create_coupon(%{code: "BYPROMOABC123", active: true, count: 10, promo_id: 4})
    {:ok, coupon2} = Coupon.Create.create_coupon(%{code: "BYPROMODEF456", active: true, count: 5, promo_id: 4})
    {:ok, coupon3} = Coupon.Create.create_coupon(%{code: "BYPROMOGHI789", active: true, count: 8, promo_id: 5})
    coupons = Coupon.Read.dump_coupons_by_promo_id(4)
    assert Enum.any?(coupons, fn coupon -> coupon.id == coupon1.id end)
    assert Enum.any?(coupons, fn coupon -> coupon.id == coupon2.id end)
    refute Enum.any?(coupons, fn coupon -> coupon.id == coupon3.id end)
  end

  test "insert_coupons/1 inserts a list of coupons" do
    cleanup()
    coupons = [
      %{code: "ABC8123", active: true, count: 10, promo_id: 1},
      %{code: "DEF8456", active: true, count: 5, promo_id: 2}
    ]
    {:ok, success_count} = Coupon.Create.insert_coupons(coupons)
    assert success_count == {2, nil}

    inserted_coupons = Tpe.Repo.all(Tpe.Coupon)
    assert length(inserted_coupons) == 2
    assert Enum.any?(inserted_coupons, fn coupon -> coupon.code == "ABC8123" end)
    assert Enum.any?(inserted_coupons, fn coupon -> coupon.code == "DEF8456" end)
  end

  test "dump_coupon_codes_by_promo_id_with_dashes/2 retrieves coupon codes by promo_id with dashes" do
    cleanup()
    promo_id = 6
    interv = 3
    coupons = [
      %{code: "ABC1234", active: true, count: 10, promo_id: 6},
      %{code: "DEF5678", active: true, count: 5, promo_id: 6},
      %{code: "GHI9101", active: true, count: 5, promo_id: 6},
      %{code: "JKL1213", active: true, count: 5, promo_id: 6}
    ]

    {:ok, _} = Tpe.Coupon.Create.insert_coupons(coupons)
    expected_codes = [
      "ABC-123-4",
      "DEF-567-8",
      "GHI-910-1",
      "JKL-121-3"
    ]


    actual_codes = Tpe.Coupon.Read.dump_coupon_codes_by_promo_id_with_dashes(promo_id, interv)

    assert expected_codes == actual_codes
    expected_undashed_codes = [
      "ABC1234",
      "DEF5678",
      "GHI9101",
      "JKL1213"
    ]

    actual_codes = Tpe.Coupon.Read.dump_coupon_codes_by_promo_id_with_dashes(promo_id, nil)

    assert expected_undashed_codes == actual_codes
  end

  test "set_active_by_promo_id/2 sets the active status of coupons by promo_id" do
    cleanup()
    promo_id = 1
    active = true

    {:ok, coupon1} = Coupon.Create.create_coupon(%{code: "ABC123", active: false, count: 10, promo_id: promo_id})
    {:ok, coupon2} = Coupon.Create.create_coupon(%{code: "DEF456", active: false, count: 5, promo_id: promo_id})
    {:ok, coupon3} = Coupon.Create.create_coupon(%{code: "GHI789", active: false, count: 8, promo_id: promo_id})
    {:ok, coupon4} = Coupon.Create.create_coupon(%{code: "GHI000", active: false, count: 8, promo_id: 8})
    Process.sleep(2000)
    assert {3, nil} == Coupon.Update.set_active_by_promo_id(promo_id, active)


    updated_coupon1 = Tpe.Repo.get(Tpe.Coupon, coupon1.id)
    updated_coupon2 = Tpe.Repo.get(Tpe.Coupon, coupon2.id)
    updated_coupon3 = Tpe.Repo.get(Tpe.Coupon, coupon3.id)
    updated_coupon4 = Tpe.Repo.get(Tpe.Coupon, coupon4.id)

    assert true == updated_coupon1.active
    assert true == updated_coupon2.active
    assert true == updated_coupon3.active
    refute true == updated_coupon4.active

    assert updated_coupon1.updated_at > coupon1.updated_at
    assert updated_coupon2.updated_at > coupon2.updated_at
    assert updated_coupon3.updated_at > coupon3.updated_at
    assert updated_coupon4.updated_at == coupon4.updated_at
  end

  test "delete_by_promo_id/1 deletes all coupons with a given promo_id" do
    cleanup()
    promo_id = 12
    {:ok, _coupon1} = Coupon.Create.create_coupon(%{code: "ABC123", active: true, count: 10, promo_id: promo_id})
    {:ok, _coupon2} = Coupon.Create.create_coupon(%{code: "DEF456", active: true, count: 5, promo_id: promo_id})
    {:ok, _coupon3} = Coupon.Create.create_coupon(%{code: "GHI789", active: true, count: 8, promo_id: promo_id})

    deleted_count = Coupon.Delete.delete_by_promo_id(promo_id)

    assert deleted_count == {3, nil}
    assert [] == Tpe.Repo.all(Tpe.Coupon)
  end

  test "delete_by_inserted_at_before/1 deletes all coupons inserted before a given date" do
    cleanup()
    {:ok, _coupon1} = Coupon.Create.create_coupon(%{code: "TIMEABC123", active: true, count: 10, promo_id: 1})
    {:ok, _coupon2} = Coupon.Create.create_coupon(%{code: "TIMEDEF456", active: true, count: 5, promo_id: 2})

    date = DateTime.utc_now()
    Process.sleep(1000)
    {:ok, _coupon3} = Coupon.Create.create_coupon(%{code: "TIMEGHI789", active: true, count: 8, promo_id: 3})
    #delete all coupons inserted before date
    deleted_count = Coupon.Delete.delete_by_inserted_at_before(date)
    assert deleted_count == {2, nil}

    #get all remaining coupons
    count = Tpe.Repo.all(Tpe.Coupon)
    |> Enum.count()

    assert count == 1
  end

  # ...
end
