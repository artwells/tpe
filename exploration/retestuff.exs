import Wongi.Engine
import Wongi.Engine.DSL
engine = new()
engine = engine |> assert({:earth, :satellite, :moon})
[fact] =
  engine
  |> select(:earth, :satellite, :_)
  |> Enum.to_list()

IO.inspect(fact.object)
# => :moon
