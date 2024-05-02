forall: [
    %Wongi.Engine.DSL.Has{subject: %Wongi.Engine.DSL.Var{name: :planet},  predicate: :satellite,  object: %Wongi.Engine.DSL.Var{name: :satellite},  filters: nil},
    %Wongi.Engine.DSL.Has{subject: %Wongi.Engine.DSL.Var{name: :planet},  predicate: :mass,  object: %Wongi.Engine.DSL.Var{name: :planet_mass},  filters: nil},
    %Wongi.Engine.DSL.Has{subject: %Wongi.Engine.DSL.Var{name: :satellite},  predicate: :mass,  object: %Wongi.Engine.DSL.Var{name: :sat_mass},  filters: nil},
    %Wongi.Engine.DSL.Has{subject: %Wongi.Engine.DSL.Var{name: :satellite},  predicate: :distance,  object: %Wongi.Engine.DSL.Var{name: :distance},  filters: nil},
    %Wongi.Engine.DSL.Assign{name: :pull,  object: "&(6.674e-11 * &1[:sat_mass] * &1[:planet_mass] / :math.pow(&1[:distance], 2))"}
  ],
  do: [
    %Wongi.Engine.Action.Generator{template: WME.new(%Wongi.Engine.DSL.Var{name: :satellite}, :pull, %Wongi.Engine.DSL.Var{    name: :pull  })}
  ]
