import Wongi.Engine
import Wongi.Engine.DSL

 biz = %{subject: var(:satellite), object: :distance, predicate: var(:distance)}

 biz2 = [var(:satellite),:distance, var(:distance)]

# tix = Enum.each(biz2, fn arg1, arg2, arg3 ->
#    has(arg1, arg2, arg3)
# end)


#tix = has(biz2|>head|head|head)
tix = apply(Wongi.Engine.DSL, :has, biz2)

rule =
  rule(
    forall: [
      has(var(:planet), :satellite, var(:satellite)),
      has(var(:planet), :mass, var(:planet_mass)),
      has(var(:satellite), :mass, var(:sat_mass)),
      tix,
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
