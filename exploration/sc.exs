defmodule Ret do
  import Wongi.Engine
  import Wongi.Engine.DSL


  defp process_arg(arg) do
    #if string begins with ":" return as atom
    if String.starts_with?(arg, ":") do
      String.to_atom(arg)
    else
      %Wongi.Engine.DSL.Var{name: arg}
    end
    https://alchemist.camp/articles/querying-nested-map-ecto
  end

  def process_has(statement) do

    #parse the statement
      args=Regex.run(~r/has\(([^,]+),\s?([^,]+),\s?([^)]+)\)+$/, String.trim(statement, " "), capture: :all_but_first)
      |> Enum.map(fn x -> process_arg(x) end)

      rule(
        forall: [
          has(var(:item), :quantity, var(:quantity)),
          has(args |> Enum.at(0), args |> Enum.at(1), args |> Enum.at(2))
        ]
      )
  end


  def get_rule_properties(promo_id \\ 1) do
    IO.puts(to_string(promo_id) <> " is the promo_id")
    #list of properties with forall/do, has/gen/assign, and properties
    rule_props = [
      %{condition: "var(:item), :item_total, var(:item_total)", block: "do", verb: "gen"},
      %{condition: "var(:item), :quantity, var(:quantity)", block: "forall", verb: "has"},
      %{condition: "var(:item), :item_sku, \"BSKU\"", block: "forall", verb: "has"},
      %{condition: "var(:item), :item_price, var(:item_price)", block: "forall", verb: "has"},
      %{condition: "var(:item_total), &(&1[:item_price] * &1[:quantity] * (1 - &1[:discount]))", block: "forall", verb: "has"},

    ]
    grouped = group_blocks(rule_props)
IO.puts (grouped)
grouped = """

defmodule Mytest do

import Wongi.Engine
import Wongi.Engine.DSL

def compiled_rule(sku, discount) do
       rule(forall: [
  has(var(:item), :discount, discount),
  has(var(:item), :quantity, var(:quantity)),
  has(var(:item), :item_price, var(:item_price)),
  has(var(:item), :item_sku, sku ),
  assign(:item_total, &(&1[:item_price] * &1[:quantity]))
],
do: [
  gen(var(:item), :item_total, var(:item_total))
])
end
end
"""

    Code.eval_string("#{grouped}")
 rule = Mytest.compiled_rule("BSKU", 1)
engine = new()
 |> compile(rule)
 |> assert(:new_item, :discount, 0.5)
 |> assert(:new_item, :quantity, 2)
 |> assert(:new_item, :item_price, 1.8)
 |> assert(:new_item, :item_sku, "BSKU")
       engine |> select(:new_item, :_, :_) |> Enum.each(&IO.inspect(&1))
     #IO.inspect(wme)


end

  def group_blocks(list)do
    #@TODO: add filter of only allowable blocks
    Enum.group_by(list, fn x -> x.block end)
    #create rule blocks with forall and do
    |> Enum.map(fn {k, v} ->  %{block: k, statement: v} end)
     |> Enum.map(fn x ->
        %{block: x.block, statement: Enum.map(x.statement, fn y -> "  " <> y.verb <> "(" <> to_string(y.condition) <> ")" end)}
       end)
       |> Enum.map(fn x -> x.block <> ": [ " <> Enum.join(x.statement, "\n") <> " ]" end)
        |> Enum.join(",\n")
   # |> Enum.reduce("", fn x, acc -> acc <> x.block <> ":" <> Enum.join(x.statement, " ") <> "\n" end)


  end

  # creates a new rule with providing a discount for a specific item
  def fixed_discount_rule(sku, discount) do
      rule(
        forall: [
          has(var(:item), :discount, discount),
          has(var(:item), :quantity, var(:quantity)),
          has(var(:item), :item_price, var(:item_price)),
          has(var(:item), :item_sku, sku ),
          assign(:item_total, &(&1[:item_price] * &1[:quantity] * (1 - &1[:discount])))
        ],
        do: [
          gen(var(:item), :item_total, var(:item_total))
        ]
      )
  end




  def tp do
    string_test = "has(var(:item), :item_sku, \"BSKU\")"
    rule =
      rule(
        forall: [
          has(var(:item), :discount, var(:discount)),
          has(var(:item), :quantity, var(:quantity)),
          has(var(:item), :item_price, var(:item_price)),
          Code.compile_string(string_test),
          assign(:item_total, &(&1[:item_price] * &1[:quantity] * (1 - &1[:discount])))
        ],
        do: [
          gen(var(:item), :item_total, var(:item_total))
        ]
      )
      rule_t =
        rule(
          forall: [
            has(var(:item), :discount, var(:discount)),
            has(var(:item), :quantity, var(:quantity)),
            has(var(:item), :item_price, var(:item_price)),
            has(var(:item), :item_category, "B"),
            assign(:item_total, &(&1[:item_price] *2))
          ],
          do: [
            gen(var(:item), :item_total, var(:item_total))
          ]
        )

        new()
        |> compile(rule)
        |> compile(rule_t)
        |> assert(:new_item, :discount, 0.5)
        |> assert(:new_item, :quantity, 2)
        |> assert(:new_item, :item_price, 1.8)
#      [wme] = engine |> select(:new_item, :_, :_) |> Enum.each(&IO.inspect(&1))
 #     IO.inspect(wme)
  end


  def try_something do
    rule =
      rule(
        forall: [
          has(var(:planet), :satellite, var(:satellite)),
          has(var(:planet), :mass, var(:planet_mass)),
          has(var(:satellite), :mass, var(:sat_mass)),
          has(var(:satellite), :distance, var(:distance)),
          assign(:pull, &(6.674e-11 * &1[:sat_mass] * &1[:planet_mass] / :math.pow(&1[:distance], 2)))
        ],
        do: [
          gen(var(:satellite), :pull, var(:pull))
        ]
      )
    engine =
      new()
      |> compile(rule)
      |> assert(:earth, :satellite, :moon)
      |> assert(:earth, :mass, 5.972e24)
      |> assert(:moon, :mass, 7.34767309e22)
      |> assert(:moon, :distance, 384_400.0e3)

    [wme] = engine |> select(:moon, :pull, :_) |> Enum.to_list()
    IO.inspect(wme.object)
  end

  def somethingelse do
    engine = new()
    engine = engine |> assert({:earth, :satellite, :moon})
    [fact] = engine |> select(:earth, :satellite, :_) |> Enum.to_list()

    IO.inspect(fact.object)
  end


end
