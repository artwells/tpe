
# :sat_mass = 7.34767309 * Abacus.eval("10^22")|>elem(0)
# :planet_mass = 5.972e24
# :distance = 384_400.0e3
# #"6.674e-11 * &1[:sat_mass] * &1[:planet_mass] / :math.pow(&1[:distance], 2)))"
#args = "(6.674 * 10^-11)* a * b / c^2"
args = "a + b + c"
#vars = %{"a" => :sat_mass, "b" => :planet_mass, "c" => :distance}
vars = %{"a" => 1, "b" => 2, "c" => 3}
{:ok, run} = Abacus.eval(args, vars)
#run = Abacus.eval("3 + 3")|>elem(1)
IO.inspect(run)
