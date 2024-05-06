import Wongi.Engine
import Wongi.Engine.DSL
engine = new()
engine = engine |> assert({:earth, :satellite, :moon})
[fact] = engine |> select(:earth, :satellite, :_) |> Enum.to_list()

IO.inspect(fact.object)
# => :moon

#########################3
rule = rule("optional name", forall: [
  {:earth, :satellite, :moon},
  {:jupiter, :satellite, :io},
  {:jupiter, :satellite, :europa},
  {:jupiter, :satellite, :ganymede},
  {:jupiter, :satellite, :callisto},
  {:mars, :satellite, :deimos},
  {:mars, :satellite, :phobos}
])

IO.inspect(rule.ref)
# => #Reference<...>
engine = engine |> compile(rule)

#################

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


#iex(38)> Enum.map(entity(engine,"Alice"), fn {a,b} -> {a,b} end)
