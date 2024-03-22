defmodule RandomCSV do
  @characters 'ABCDEFGHJKLMNPQRTUVWXY346789' |> to_string() |> String.split("", trim: true)
  @numbers Enum.to_list(20..30)

  def generate do
    1..2_000
    |> Enum.map(fn _ -> generate_line() end)
    |> Enum.join("\n")
  end

  defp generate_line do
    random_characters = Enum.take_random(@characters, 24) |> Enum.join("")
    random_number = Enum.random(@numbers)
    "#{random_characters},#{random_number}"
  end
end

File.write!("coupons_with_promo_id.csv", RandomCSV.generate())
