defmodule RandomCSV do
  @characters ~c"ABCDEFGHJKLMNPQRTUVWXY346789" |> to_string() |> String.split("", trim: true)
  @numbers Enum.to_list(20..30)

  def generate(no_promo_id \\ nil) do
    1..2_000
    |> Enum.map(fn _ -> generate_line(no_promo_id) end)
    |> Enum.join("\n")
  end

  defp generate_line(no_promo_id) do
    random_characters = Enum.take_random(@characters, 24) |> Enum.join("")
    random_number = Enum.random(@numbers)

    if no_promo_id do
      "#{random_characters}"
    else
      "#{random_characters},#{random_number}"
    end
  end
end

File.write!("coupons_with_promo_id.csv", RandomCSV.generate())
File.write!("coupons.csv", RandomCSV.generate(:no_promo_id))
