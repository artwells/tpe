Remember to keep good posture and stay hydrated!

19:04:15.456 [debug] QUERY OK source="rule" db=12.8ms decode=1.2ms queue=1.8ms idle=24.6ms
INSERT INTO "rule" ("name","type","description","updated_at") VALUES ($1,$2,$3,$4) RETURNING "id" ["Rule 1", "basic", "a new rule", ~U[2024-05-10 19:04:15.411381Z]]

19:04:15.483 [debug] QUERY OK source="rule_parts" db=17.7ms queue=1.8ms idle=57.7ms
INSERT INTO "rule_parts" ("block","arguments","updated_at","rule_id","verb") VALUES ($1,$2,$3,$4,$5) RETURNING "id" ["forall", %{object: "var(:satellite)", predicate: :satellite, subject: "var(:planet)"}, ~U[2024-05-10 19:04:15.459633Z], 1514, "has"]

19:04:15.492 [debug] QUERY OK source="rule_parts" db=7.0ms queue=1.8ms idle=81.4ms
INSERT INTO "rule_parts" ("block","arguments","updated_at","rule_id","verb") VALUES ($1,$2,$3,$4,$5) RETURNING "id" ["forall", %{object: "var(:planet_mass)", predicate: :mass, subject: "var(:planet)"}, ~U[2024-05-10 19:04:15.483259Z], 1514, "has"]

19:04:15.502 [debug] QUERY OK source="rule_parts" db=8.6ms queue=0.9ms idle=90.5ms
INSERT INTO "rule_parts" ("block","arguments","updated_at","rule_id","verb") VALUES ($1,$2,$3,$4,$5) RETURNING "id" ["forall", %{object: "var(:sat_mass)", predicate: :mass, subject: "var(:satellite)"}, ~U[2024-05-10 19:04:15.492450Z], 1514, "has"]

19:04:15.508 [debug] QUERY OK source="rule_parts" db=5.1ms queue=0.9ms idle=100.3ms
INSERT INTO "rule_parts" ("block","arguments","updated_at","rule_id","verb") VALUES ($1,$2,$3,$4,$5) RETURNING "id" ["forall", %{object: "var(:distance)", predicate: :distance, subject: "var(:satellite)"}, ~U[2024-05-10 19:04:15.502283Z], 1514, "has"]

19:04:15.513 [debug] QUERY OK source="rule_parts" db=4.4ms queue=0.5ms idle=106.7ms
INSERT INTO "rule_parts" ("block","arguments","updated_at","rule_id","verb") VALUES ($1,$2,$3,$4,$5) RETURNING "id" ["forall", %{name: :pull, value: "&( 0.5 * &1[:sat_mass] * &1[:planet_mass] * &1[:distance])", eval: "dune"}, ~U[2024-05-10 19:04:15.508680Z], 1514, "assign"]

19:04:15.520 [debug] QUERY OK source="rule_parts" db=5.3ms queue=0.6ms idle=112.0ms
INSERT INTO "rule_parts" ("block","arguments","updated_at","rule_id","verb") VALUES ($1,$2,$3,$4,$5) RETURNING "id" ["do", %{object: "var(:pull)", predicate: :pull, subject: "var(:satellite)"}, ~U[2024-05-10 19:04:15.514000Z], 1514, "generator"]

19:04:15.526 [debug] QUERY OK source="rule" db=5.4ms queue=1.1ms idle=118.2ms
INSERT INTO "rule" ("name","type","description","updated_at") VALUES ($1,$2,$3,$4) RETURNING "id" ["Rule 2", "basic", "some a new rule", ~U[2024-05-10 19:04:15.520162Z]]

19:04:15.533 [debug] QUERY OK source="rule_parts" db=5.3ms queue=0.9ms idle=125.2ms
INSERT INTO "rule_parts" ("block","arguments","updated_at","rule_id","verb") VALUES ($1,$2,$3,$4,$5) RETURNING "id" ["forall", %{object: "var(:satellite)", predicate: :satellite, subject: "var(:planet)"}, ~U[2024-05-10 19:04:15.527096Z], 1515, "has"]

19:04:15.541 [debug] QUERY OK source="rule_parts" db=7.0ms queue=0.8ms idle=131.7ms
INSERT INTO "rule_parts" ("block","arguments","updated_at","rule_id","verb") VALUES ($1,$2,$3,$4,$5) RETURNING "id" ["forall", %{object: "var(:planet_mass)", predicate: :mass, subject: "var(:planet)"}, ~U[2024-05-10 19:04:15.533733Z], 1515, "has"]

19:04:15.549 [debug] QUERY OK source="rule_parts" db=6.4ms queue=1.1ms idle=100.9ms
INSERT INTO "rule_parts" ("block","arguments","updated_at","rule_id","verb") VALUES ($1,$2,$3,$4,$5) RETURNING "id" ["forall", %{object: "var(:sat_mass)", predicate: :mass, subject: "var(:satellite)"}, ~U[2024-05-10 19:04:15.542033Z], 1515, "has"]

19:04:15.556 [debug] QUERY OK source="rule_parts" db=5.3ms queue=0.1ms idle=70.9ms
INSERT INTO "rule_parts" ("block","arguments","updated_at","rule_id","verb") VALUES ($1,$2,$3,$4,$5) RETURNING "id" ["forall", %{object: "var(:distance)", predicate: :distance, subject: "var(:satellite)"}, ~U[2024-05-10 19:04:15.550096Z], 1515, "has"]

19:04:15.563 [debug] QUERY OK source="rule_parts" db=5.8ms idle=64.8ms
INSERT INTO "rule_parts" ("block","arguments","updated_at","rule_id","verb") VALUES ($1,$2,$3,$4,$5) RETURNING "id" ["forall", %{name: :pull2, value: "&(&1[:sat_mass] * &1[:planet_mass] * &1[:distance])", eval: "dune"}, ~U[2024-05-10 19:04:15.557013Z], 1515, "assign"]

19:04:15.570 [debug] QUERY OK source="rule_parts" db=6.2ms queue=0.1ms idle=61.7ms
INSERT INTO "rule_parts" ("block","arguments","updated_at","rule_id","verb") VALUES ($1,$2,$3,$4,$5) RETURNING "id" ["do", %{object: "var(:pull2)", predicate: :pull2, subject: "var(:satellite)"}, ~U[2024-05-10 19:04:15.563694Z], 1515, "generator"]

19:04:15.597 [debug] QUERY OK source="rule_parts" db=7.4ms queue=1.0ms idle=80.0ms
SELECT r0."id", r0."rule_id", r0."block", r0."verb", r0."arguments", r0."inserted_at", r0."updated_at" FROM "rule_parts" AS r0 WHERE (r0."rule_id" = $1) [1514]

19:04:15.646 [debug] QUERY OK source="rule_parts" db=0.8ms idle=132.2ms
SELECT r0."id", r0."rule_id", r0."block", r0."verb", r0."arguments", r0."inserted_at", r0."updated_at" FROM "rule_parts" AS r0 WHERE (r0."rule_id" = $1) [1515]
#Wongi.Engine.Rete<
  overlay: %Wongi.Engine.Overlay{
    wmes: MapSet.new([WME.new(:moon, :distance, 3),
     WME.new(:earth, :mass, 5.972), WME.new(:moon, :mass, 7.34767309),
     WME.new(:moon, :pull, 65.82045554022),
     WME.new(:moon, :pull2, 131.64091108044),
     WME.new(:earth, :satellite, :moon)]),
    indexes: %{
      [:object] => %Wongi.Engine.AlphaIndex{
        fields: [:object],
        entries: %{
          [3] => MapSet.new([WME.new(:moon, :distance, 3)]),
          [5.972] => MapSet.new([WME.new(:earth, :mass, 5.972)]),
          [7.34767309] => MapSet.new([WME.new(:moon, :mass, 7.34767309)]),
          [65.82045554022] => MapSet.new([WME.new(:moon, :pull, 65.82045554022)]),
          [131.64091108044] => MapSet.new([WME.new(:moon, :pull2, 131.64091108044)]),
          [:moon] => MapSet.new([WME.new(:earth, :satellite, :moon)])
        }
      },
      [:predicate] => %Wongi.Engine.AlphaIndex{
        fields: [:predicate],
        entries: %{
          [:distance] => MapSet.new([WME.new(:moon, :distance, 3)]),
          [:mass] => MapSet.new([WME.new(:earth, :mass, 5.972),
           WME.new(:moon, :mass, 7.34767309)]),
          [:pull] => MapSet.new([WME.new(:moon, :pull, 65.82045554022)]),
          [:pull2] => MapSet.new([WME.new(:moon, :pull2, 131.64091108044)]),
          [:satellite] => MapSet.new([WME.new(:earth, :satellite, :moon)])
        }
      },
      [:predicate, :object] => %Wongi.Engine.AlphaIndex{
        fields: [:predicate, :object],
        entries: %{
          [:distance, 3] => MapSet.new([WME.new(:moon, :distance, 3)]),
          [:mass, 5.972] => MapSet.new([WME.new(:earth, :mass, 5.972)]),
          [:mass, 7.34767309] => MapSet.new([WME.new(:moon, :mass, 7.34767309)]),
          [:pull, 65.82045554022] => MapSet.new([WME.new(:moon, :pull, 65.82045554022)]),
          [:pull2, 131.64091108044] => MapSet.new([WME.new(:moon, :pull2, 131.64091108044)]),
          [:satellite, :moon] => MapSet.new([WME.new(:earth, :satellite, :moon)])
        }
      },
      [:subject] => %Wongi.Engine.AlphaIndex{
        fields: [:subject],
        entries: %{
          [:earth] => MapSet.new([WME.new(:earth, :mass, 5.972),
           WME.new(:earth, :satellite, :moon)]),
          [:moon] => MapSet.new([WME.new(:moon, :distance, 3),
           WME.new(:moon, :mass, 7.34767309),
           WME.new(:moon, :pull, 65.82045554022),
           WME.new(:moon, :pull2, 131.64091108044)])
        }
      },
      [:subject, :object] => %Wongi.Engine.AlphaIndex{
        fields: [:subject, :object],
        entries: %{
          [:earth, 5.972] => MapSet.new([WME.new(:earth, :mass, 5.972)]),
          [:earth, :moon] => MapSet.new([WME.new(:earth, :satellite, :moon)]),
          [:moon, 3] => MapSet.new([WME.new(:moon, :distance, 3)]),
          [:moon, 7.34767309] => MapSet.new([WME.new(:moon, :mass, 7.34767309)]),
          [:moon, 65.82045554022] => MapSet.new([WME.new(:moon, :pull, 65.82045554022)]),
          [:moon, 131.64091108044] => MapSet.new([WME.new(:moon, :pull2, 131.64091108044)])
        }
      },
      [:subject, :predicate] => %Wongi.Engine.AlphaIndex{
        fields: [:subject, :predicate],
        entries: %{
          [:earth, :mass] => MapSet.new([WME.new(:earth, :mass, 5.972)]),
          [:earth, :satellite] => MapSet.new([WME.new(:earth, :satellite, :moon)]),
          [:moon, :distance] => MapSet.new([WME.new(:moon, :distance, 3)]),
          [:moon, :mass] => MapSet.new([WME.new(:moon, :mass, 7.34767309)]),
          [:moon, :pull] => MapSet.new([WME.new(:moon, :pull, 65.82045554022)]),
          [:moon, :pull2] => MapSet.new([WME.new(:moon, :pull2, 131.64091108044)])
        }
      }
    },
    manual: MapSet.new([WME.new(:moon, :distance, 3),
     WME.new(:earth, :mass, 5.972), WME.new(:moon, :mass, 7.34767309),
     WME.new(:earth, :satellite, :moon)]),
    tokens: %{
      #Reference<0.3769196364.2147745798.66274> => MapSet.new([
        %Wongi.Engine.Token{
          ref: #Reference<0.3769196364.2147745798.66384>,
          node_ref: #Reference<0.3769196364.2147745798.66274>,
          parents: MapSet.new([
            %Wongi.Engine.Token{
              ref: #Reference<0.3769196364.2147745798.66383>,
              node_ref: #Reference<0.3769196364.2147745798.66375>,
              parents: MapSet.new([
                %Wongi.Engine.Token{
                  ref: #Reference<0.3769196364.2147745798.66382>,
                  node_ref: #Reference<0.3769196364.2147745798.66349>,
                  parents: MapSet.new([
                    %Wongi.Engine.Token{
                      ref: #Reference<0.3769196364.2147745798.66381>,
                      node_ref: #Reference<0.3769196364.2147745798.66348>,
                      parents: MapSet.new([
                        %Wongi.Engine.Token{
                          ref: #Reference<0.3769196364.2147745798.66380>,
                          node_ref: #Reference<0.3769196364.2147745798.66347>,
                          parents: MapSet.new([
                            %Wongi.Engine.Token{
                              ref: #Reference<0.3769196364.2147745798.66338>,
                              node_ref: #Reference<0.3769196364.2147745798.66325>,
                              parents: MapSet.new([]),
                              wme: nil,
                              assignments: %{}
                            }
                          ]),
                          wme: WME.new(:earth, :satellite, :moon),
                          assignments: %{planet: :earth, satellite: :moon}
                        }
                      ]),
                      wme: WME.new(:earth, :mass, 5.972),
                      assignments: %{planet_mass: 5.972}
                    }
                  ]),
                  wme: WME.new(:moon, :mass, 7.34767309),
                  assignments: %{sat_mass: 7.34767309}
                }
              ]),
              wme: WME.new(:moon, :distance, 3),
              assignments: %{distance: 3}
            }
          ]),
          wme: nil,
          assignments: %{pull: 65.82045554022}
        }
      ]),
      #Reference<0.3769196364.2147745798.66275> => MapSet.new([
        %Wongi.Engine.Token{
          ref: #Reference<0.3769196364.2147745798.66394>,
          node_ref: #Reference<0.3769196364.2147745798.66275>,
          parents: MapSet.new([
            %Wongi.Engine.Token{
              ref: #Reference<0.3769196364.2147745798.66393>,
              node_ref: #Reference<0.3769196364.2147745798.66358>,
              parents: MapSet.new([
                %Wongi.Engine.Token{
                  ref: #Reference<0.3769196364.2147745798.66382>,
                  node_ref: #Reference<0.3769196364.2147745798.66349>,
                  parents: MapSet.new([
                    %Wongi.Engine.Token{
                      ref: #Reference<0.3769196364.2147745798.66381>,
                      node_ref: #Reference<0.3769196364.2147745798.66348>,
                      parents: MapSet.new([
                        %Wongi.Engine.Token{
                          ref: #Reference<0.3769196364.2147745798.66380>,
                          node_ref: #Reference<0.3769196364.2147745798.66347>,
                          parents: MapSet.new([
                            %Wongi.Engine.Token{
                              ref: #Reference<0.3769196364.2147745798.66338>,
                              node_ref: #Reference<0.3769196364.2147745798.66325>,
                              parents: MapSet.new([]),
                              wme: nil,
                              assignments: %{}
                            }
                          ]),
                          wme: WME.new(:earth, :satellite, :moon),
                          assignments: %{planet: :earth, satellite: :moon}
                        }
                      ]),
                      wme: WME.new(:earth, :mass, 5.972),
                      assignments: %{planet_mass: 5.972}
                    }
                  ]),
                  wme: WME.new(:moon, :mass, 7.34767309),
                  assignments: %{sat_mass: 7.34767309}
                }
              ]),
              wme: WME.new(:moon, :distance, 3),
              assignments: %{distance: 3}
            }
          ]),
          wme: nil,
          assignments: %{pull2: 131.64091108044}
        }
      ]),
      #Reference<0.3769196364.2147745798.66325> => MapSet.new([
        %Wongi.Engine.Token{
          ref: #Reference<0.3769196364.2147745798.66338>,
          node_ref: #Reference<0.3769196364.2147745798.66325>,
          parents: MapSet.new([]),
          wme: nil,
          assignments: %{}
        }
      ]),
      #Reference<0.3769196364.2147745798.66347> => MapSet.new([
        %Wongi.Engine.Token{
          ref: #Reference<0.3769196364.2147745798.66380>,
          node_ref: #Reference<0.3769196364.2147745798.66347>,
          parents: MapSet.new([
            %Wongi.Engine.Token{
              ref: #Reference<0.3769196364.2147745798.66338>,
              node_ref: #Reference<0.3769196364.2147745798.66325>,
              parents: MapSet.new([]),
              wme: nil,
              assignments: %{}
            }
          ]),
          wme: WME.new(:earth, :satellite, :moon),
          assignments: %{planet: :earth, satellite: :moon}
        }
      ]),
      #Reference<0.3769196364.2147745798.66348> => MapSet.new([
        %Wongi.Engine.Token{
          ref: #Reference<0.3769196364.2147745798.66381>,
          node_ref: #Reference<0.3769196364.2147745798.66348>,
          parents: MapSet.new([
            %Wongi.Engine.Token{
              ref: #Reference<0.3769196364.2147745798.66380>,
              node_ref: #Reference<0.3769196364.2147745798.66347>,
              parents: MapSet.new([
                %Wongi.Engine.Token{
                  ref: #Reference<0.3769196364.2147745798.66338>,
                  node_ref: #Reference<0.3769196364.2147745798.66325>,
                  parents: MapSet.new([]),
                  wme: nil,
                  assignments: %{}
                }
              ]),
              wme: WME.new(:earth, :satellite, :moon),
              assignments: %{planet: :earth, satellite: :moon}
            }
          ]),
          wme: WME.new(:earth, :mass, 5.972),
          assignments: %{planet_mass: 5.972}
        }
      ]),
      #Reference<0.3769196364.2147745798.66349> => MapSet.new([
        %Wongi.Engine.Token{
          ref: #Reference<0.3769196364.2147745798.66382>,
          node_ref: #Reference<0.3769196364.2147745798.66349>,
          parents: MapSet.new([
            %Wongi.Engine.Token{
              ref: #Reference<0.3769196364.2147745798.66381>,
              node_ref: #Reference<0.3769196364.2147745798.66348>,
              parents: MapSet.new([
                %Wongi.Engine.Token{
                  ref: #Reference<0.3769196364.2147745798.66380>,
                  node_ref: #Reference<0.3769196364.2147745798.66347>,
                  parents: MapSet.new([
                    %Wongi.Engine.Token{
                      ref: #Reference<0.3769196364.2147745798.66338>,
                      node_ref: #Reference<0.3769196364.2147745798.66325>,
                      parents: MapSet.new([]),
                      wme: nil,
                      assignments: %{}
                    }
                  ]),
                  wme: WME.new(:earth, :satellite, :moon),
                  assignments: %{planet: :earth, satellite: :moon}
                }
              ]),
              wme: WME.new(:earth, :mass, 5.972),
              assignments: %{planet_mass: 5.972}
            }
          ]),
          wme: WME.new(:moon, :mass, 7.34767309),
          assignments: %{sat_mass: 7.34767309}
        }
      ]),
      #Reference<0.3769196364.2147745798.66358> => MapSet.new([
        %Wongi.Engine.Token{
          ref: #Reference<0.3769196364.2147745798.66393>,
          node_ref: #Reference<0.3769196364.2147745798.66358>,
          parents: MapSet.new([
            %Wongi.Engine.Token{
              ref: #Reference<0.3769196364.2147745798.66382>,
              node_ref: #Reference<0.3769196364.2147745798.66349>,
              parents: MapSet.new([
                %Wongi.Engine.Token{
                  ref: #Reference<0.3769196364.2147745798.66381>,
                  node_ref: #Reference<0.3769196364.2147745798.66348>,
                  parents: MapSet.new([
                    %Wongi.Engine.Token{
                      ref: #Reference<0.3769196364.2147745798.66380>,
                      node_ref: #Reference<0.3769196364.2147745798.66347>,
                      parents: MapSet.new([
                        %Wongi.Engine.Token{
                          ref: #Reference<0.3769196364.2147745798.66338>,
                          node_ref: #Reference<0.3769196364.2147745798.66325>,
                          parents: MapSet.new([]),
                          wme: nil,
                          assignments: %{}
                        }
                      ]),
                      wme: WME.new(:earth, :satellite, :moon),
                      assignments: %{planet: :earth, satellite: :moon}
                    }
                  ]),
                  wme: WME.new(:earth, :mass, 5.972),
                  assignments: %{planet_mass: 5.972}
                }
              ]),
              wme: WME.new(:moon, :mass, 7.34767309),
              assignments: %{sat_mass: 7.34767309}
            }
          ]),
          wme: WME.new(:moon, :distance, 3),
          assignments: %{distance: 3}
        }
      ]),
      #Reference<0.3769196364.2147745798.66375> => MapSet.new([
        %Wongi.Engine.Token{
          ref: #Reference<0.3769196364.2147745798.66383>,
          node_ref: #Reference<0.3769196364.2147745798.66375>,
          parents: MapSet.new([
            %Wongi.Engine.Token{
              ref: #Reference<0.3769196364.2147745798.66382>,
              node_ref: #Reference<0.3769196364.2147745798.66349>,
              parents: MapSet.new([
                %Wongi.Engine.Token{
                  ref: #Reference<0.3769196364.2147745798.66381>,
                  node_ref: #Reference<0.3769196364.2147745798.66348>,
                  parents: MapSet.new([
                    %Wongi.Engine.Token{
                      ref: #Reference<0.3769196364.2147745798.66380>,
                      node_ref: #Reference<0.3769196364.2147745798.66347>,
                      parents: MapSet.new([
                        %Wongi.Engine.Token{
                          ref: #Reference<0.3769196364.2147745798.66338>,
                          node_ref: #Reference<0.3769196364.2147745798.66325>,
                          parents: MapSet.new([]),
                          wme: nil,
                          assignments: %{}
                        }
                      ]),
                      wme: WME.new(:earth, :satellite, :moon),
                      assignments: %{planet: :earth, satellite: :moon}
                    }
                  ]),
                  wme: WME.new(:earth, :mass, 5.972),
                  assignments: %{planet_mass: 5.972}
                }
              ]),
              wme: WME.new(:moon, :mass, 7.34767309),
              assignments: %{sat_mass: 7.34767309}
            }
          ]),
          wme: WME.new(:moon, :distance, 3),
          assignments: %{distance: 3}
        }
      ])
    },
    neg_join_results: %Wongi.Engine.Overlay.JoinResults{
      by_wme: %{},
      by_token: %{}
    },
    generation_tracker: %Wongi.Engine.Overlay.GenerationTracker{
      by_wme: %{
        WME.new(:moon, :pull, 65.82045554022) => MapSet.new([
          %Wongi.Engine.Token{
            ref: #Reference<0.3769196364.2147745798.66384>,
            node_ref: #Reference<0.3769196364.2147745798.66274>,
            parents: MapSet.new([
              %Wongi.Engine.Token{
                ref: #Reference<0.3769196364.2147745798.66383>,
                node_ref: #Reference<0.3769196364.2147745798.66375>,
                parents: MapSet.new([
                  %Wongi.Engine.Token{
                    ref: #Reference<0.3769196364.2147745798.66382>,
                    node_ref: #Reference<0.3769196364.2147745798.66349>,
                    parents: MapSet.new([
                      %Wongi.Engine.Token{
                        ref: #Reference<0.3769196364.2147745798.66381>,
                        node_ref: #Reference<0.3769196364.2147745798.66348>,
                        parents: MapSet.new([
                          %Wongi.Engine.Token{
                            ref: #Reference<0.3769196364.2147745798.66380>,
                            node_ref: #Reference<0.3769196364.2147745798.66347>,
                            parents: MapSet.new([
                              %Wongi.Engine.Token{
                                ref: #Reference<0.3769196364.2147745798.66338>,
                                node_ref: #Reference<0.3769196364.2147745798.66325>,
                                parents: MapSet.new([]),
                                wme: nil,
                                assignments: %{}
                              }
                            ]),
                            wme: WME.new(:earth, :satellite, :moon),
                            assignments: %{planet: :earth, satellite: :moon}
                          }
                        ]),
                        wme: WME.new(:earth, :mass, 5.972),
                        assignments: %{planet_mass: 5.972}
                      }
                    ]),
                    wme: WME.new(:moon, :mass, 7.34767309),
                    assignments: %{sat_mass: 7.34767309}
                  }
                ]),
                wme: WME.new(:moon, :distance, 3),
                assignments: %{distance: 3}
              }
            ]),
            wme: nil,
            assignments: %{pull: 65.82045554022}
          }
        ]),
        WME.new(:moon, :pull2, 131.64091108044) => MapSet.new([
          %Wongi.Engine.Token{
            ref: #Reference<0.3769196364.2147745798.66394>,
            node_ref: #Reference<0.3769196364.2147745798.66275>,
            parents: MapSet.new([
              %Wongi.Engine.Token{
                ref: #Reference<0.3769196364.2147745798.66393>,
                node_ref: #Reference<0.3769196364.2147745798.66358>,
                parents: MapSet.new([
                  %Wongi.Engine.Token{
                    ref: #Reference<0.3769196364.2147745798.66382>,
                    node_ref: #Reference<0.3769196364.2147745798.66349>,
                    parents: MapSet.new([
                      %Wongi.Engine.Token{
                        ref: #Reference<0.3769196364.2147745798.66381>,
                        node_ref: #Reference<0.3769196364.2147745798.66348>,
                        parents: MapSet.new([
                          %Wongi.Engine.Token{
                            ref: #Reference<0.3769196364.2147745798.66380>,
                            node_ref: #Reference<0.3769196364.2147745798.66347>,
                            parents: MapSet.new([
                              %Wongi.Engine.Token{
                                ref: #Reference<0.3769196364.2147745798.66338>,
                                node_ref: #Reference<0.3769196364.2147745798.66325>,
                                parents: MapSet.new([]),
                                wme: nil,
                                assignments: %{}
                              }
                            ]),
                            wme: WME.new(:earth, :satellite, :moon),
                            assignments: %{planet: :earth, satellite: :moon}
                          }
                        ]),
                        wme: WME.new(:earth, :mass, 5.972),
                        assignments: %{planet_mass: 5.972}
                      }
                    ]),
                    wme: WME.new(:moon, :mass, 7.34767309),
                    assignments: %{sat_mass: 7.34767309}
                  }
                ]),
                wme: WME.new(:moon, :distance, 3),
                assignments: %{distance: 3}
              }
            ]),
            wme: nil,
            assignments: %{pull2: 131.64091108044}
          }
        ])
      },
      by_token: %{
        %Wongi.Engine.Token{
          ref: #Reference<0.3769196364.2147745798.66384>,
          node_ref: #Reference<0.3769196364.2147745798.66274>,
          parents: MapSet.new([
            %Wongi.Engine.Token{
              ref: #Reference<0.3769196364.2147745798.66383>,
              node_ref: #Reference<0.3769196364.2147745798.66375>,
              parents: MapSet.new([
                %Wongi.Engine.Token{
                  ref: #Reference<0.3769196364.2147745798.66382>,
                  node_ref: #Reference<0.3769196364.2147745798.66349>,
                  parents: MapSet.new([
                    %Wongi.Engine.Token{
                      ref: #Reference<0.3769196364.2147745798.66381>,
                      node_ref: #Reference<0.3769196364.2147745798.66348>,
                      parents: MapSet.new([
                        %Wongi.Engine.Token{
                          ref: #Reference<0.3769196364.2147745798.66380>,
                          node_ref: #Reference<0.3769196364.2147745798.66347>,
                          parents: MapSet.new([
                            %Wongi.Engine.Token{
                              ref: #Reference<0.3769196364.2147745798.66338>,
                              node_ref: #Reference<0.3769196364.2147745798.66325>,
                              parents: MapSet.new([]),
                              wme: nil,
                              assignments: %{}
                            }
                          ]),
                          wme: WME.new(:earth, :satellite, :moon),
                          assignments: %{planet: :earth, satellite: :moon}
                        }
                      ]),
                      wme: WME.new(:earth, :mass, 5.972),
                      assignments: %{planet_mass: 5.972}
                    }
                  ]),
                  wme: WME.new(:moon, :mass, 7.34767309),
                  assignments: %{sat_mass: 7.34767309}
                }
              ]),
              wme: WME.new(:moon, :distance, 3),
              assignments: %{distance: 3}
            }
          ]),
          wme: nil,
          assignments: %{pull: 65.82045554022}
        } => MapSet.new([WME.new(:moon, :pull, 65.82045554022)]),
        %Wongi.Engine.Token{
          ref: #Reference<0.3769196364.2147745798.66394>,
          node_ref: #Reference<0.3769196364.2147745798.66275>,
          parents: MapSet.new([
            %Wongi.Engine.Token{
              ref: #Reference<0.3769196364.2147745798.66393>,
              node_ref: #Reference<0.3769196364.2147745798.66358>,
              parents: MapSet.new([
                %Wongi.Engine.Token{
                  ref: #Reference<0.3769196364.2147745798.66382>,
                  node_ref: #Reference<0.3769196364.2147745798.66349>,
                  parents: MapSet.new([
                    %Wongi.Engine.Token{
                      ref: #Reference<0.3769196364.2147745798.66381>,
                      node_ref: #Reference<0.3769196364.2147745798.66348>,
                      parents: MapSet.new([
                        %Wongi.Engine.Token{
                          ref: #Reference<0.3769196364.2147745798.66380>,
                          node_ref: #Reference<0.3769196364.2147745798.66347>,
                          parents: MapSet.new([
                            %Wongi.Engine.Token{
                              ref: #Reference<0.3769196364.2147745798.66338>,
                              node_ref: #Reference<0.3769196364.2147745798.66325>,
                              parents: MapSet.new([]),
                              wme: nil,
                              assignments: %{}
                            }
                          ]),
                          wme: WME.new(:earth, :satellite, :moon),
                          assignments: %{planet: :earth, satellite: :moon}
                        }
                      ]),
                      wme: WME.new(:earth, :mass, 5.972),
                      assignments: %{planet_mass: 5.972}
                    }
                  ]),
                  wme: WME.new(:moon, :mass, 7.34767309),
                  assignments: %{sat_mass: 7.34767309}
                }
              ]),
              wme: WME.new(:moon, :distance, 3),
              assignments: %{distance: 3}
            }
          ]),
          wme: nil,
          assignments: %{pull2: 131.64091108044}
        } => MapSet.new([WME.new(:moon, :pull2, 131.64091108044)])
      }
    },
    ncc_tokens: %{},
    ncc_owners: %{}
  },
  alpha_subscriptions: %{
    [:_, :distance, :_] => [#Reference<0.3769196364.2147745798.66349>],
    [:_, :mass, :_] => [#Reference<0.3769196364.2147745798.66348>,
     #Reference<0.3769196364.2147745798.66347>],
    [:_, :satellite, :_] => [#Reference<0.3769196364.2147745798.66325>]
  },
  beta_root: %Wongi.Engine.Beta.Root{
    ref: #Reference<0.3769196364.2147745798.66284>
  },
  beta_table: %{
    #Reference<0.3769196364.2147745798.66274> => %Wongi.Engine.Beta.Production{
      ref: #Reference<0.3769196364.2147745798.66274>,
      parent_ref: #Reference<0.3769196364.2147745798.66375>,
      actions: [
        %Wongi.Engine.Action.Generator{
          template: WME.new(%Wongi.Engine.DSL.Var{name: :satellite}, :pull, %Wongi.Engine.DSL.Var{
            name: :pull
          })
        }
      ]
    },
    #Reference<0.3769196364.2147745798.66275> => %Wongi.Engine.Beta.Production{
      ref: #Reference<0.3769196364.2147745798.66275>,
      parent_ref: #Reference<0.3769196364.2147745798.66358>,
      actions: [
        %Wongi.Engine.Action.Generator{
          template: WME.new(%Wongi.Engine.DSL.Var{name: :satellite}, :pull2, %Wongi.Engine.DSL.Var{
            name: :pull2
          })
        }
      ]
    },
    #Reference<0.3769196364.2147745798.66284> => %Wongi.Engine.Beta.Root{
      ref: #Reference<0.3769196364.2147745798.66284>
    },
    #Reference<0.3769196364.2147745798.66325> => %Wongi.Engine.Beta.Join{
      ref: #Reference<0.3769196364.2147745798.66325>,
      parent_ref: #Reference<0.3769196364.2147745798.66284>,
      template: WME.new(:_, :satellite, :_),
      tests: %{},
      assignments: %{object: :satellite, subject: :planet},
      filters: nil
    },
    #Reference<0.3769196364.2147745798.66347> => %Wongi.Engine.Beta.Join{
      ref: #Reference<0.3769196364.2147745798.66347>,
      parent_ref: #Reference<0.3769196364.2147745798.66325>,
      template: WME.new(:_, :mass, :_),
      tests: %{subject: :planet},
      assignments: %{object: :planet_mass},
      filters: nil
    },
    #Reference<0.3769196364.2147745798.66348> => %Wongi.Engine.Beta.Join{
      ref: #Reference<0.3769196364.2147745798.66348>,
      parent_ref: #Reference<0.3769196364.2147745798.66347>,
      template: WME.new(:_, :mass, :_),
      tests: %{subject: :satellite},
      assignments: %{object: :sat_mass},
      filters: nil
    },
    #Reference<0.3769196364.2147745798.66349> => %Wongi.Engine.Beta.Join{
      ref: #Reference<0.3769196364.2147745798.66349>,
      parent_ref: #Reference<0.3769196364.2147745798.66348>,
      template: WME.new(:_, :distance, :_),
      tests: %{subject: :satellite},
      assignments: %{object: :distance},
      filters: nil
    },
    #Reference<0.3769196364.2147745798.66358> => %Wongi.Engine.Beta.Assign{
      ref: #Reference<0.3769196364.2147745798.66358>,
      parent_ref: #Reference<0.3769196364.2147745798.66349>,
      name: :pull2,
      value: #Function<42.105768164/1 in :erl_eval.expr/6>
    },
    #Reference<0.3769196364.2147745798.66375> => %Wongi.Engine.Beta.Assign{
      ref: #Reference<0.3769196364.2147745798.66375>,
      parent_ref: #Reference<0.3769196364.2147745798.66349>,
      name: :pull,
      value: #Function<42.105768164/1 in :erl_eval.expr/6>
    }
  },
  beta_subscriptions: %{
    #Reference<0.3769196364.2147745798.66284> => [#Reference<0.3769196364.2147745798.66325>],
    #Reference<0.3769196364.2147745798.66325> => [#Reference<0.3769196364.2147745798.66347>],
    #Reference<0.3769196364.2147745798.66347> => [#Reference<0.3769196364.2147745798.66348>],
    #Reference<0.3769196364.2147745798.66348> => [#Reference<0.3769196364.2147745798.66349>],
    #Reference<0.3769196364.2147745798.66349> => [#Reference<0.3769196364.2147745798.66375>,
     #Reference<0.3769196364.2147745798.66358>],
    #Reference<0.3769196364.2147745798.66358> => [#Reference<0.3769196364.2147745798.66275>],
    #Reference<0.3769196364.2147745798.66375> => [#Reference<0.3769196364.2147745798.66274>]
  },
  productions: MapSet.new([#Reference<0.3769196364.2147745798.66274>,
   #Reference<0.3769196364.2147745798.66275>]),
  processing: false,
  ...
>
