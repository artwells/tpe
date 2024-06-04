Remember to keep good posture and stay hydrated!

18:22:06.752 [debug] QUERY OK source="rule" db=6.7ms decode=0.7ms queue=0.7ms idle=3.3ms
INSERT INTO "rule" ("active","name","type","description","updated_at") VALUES ($1,$2,$3,$4,$5) RETURNING "id" [true, "promo 1", "basic", "a new promo", ~U[2024-06-03 18:22:06.709000Z]]

18:22:06.768 [debug] QUERY OK source="rule_parts" db=10.2ms queue=2.1ms idle=23.9ms
INSERT INTO "rule_parts" ("block","arguments","updated_at","rule_id","verb") VALUES ($1,$2,$3,$4,$5) RETURNING "id" ["do", %{object: "var(:base_total)", predicate: :base_total, subject: "var(:item)"}, ~U[2024-06-03 18:22:06.754746Z], 94, "generator"]

18:22:06.776 [debug] QUERY OK source="rule_parts" db=6.0ms queue=0.9ms idle=38.2ms
INSERT INTO "rule_parts" ("block","arguments","updated_at","rule_id","verb") VALUES ($1,$2,$3,$4,$5) RETURNING "id" ["do", %{object: "var(:discounted_total)", predicate: :discounted_total, subject: "var(:item)"}, ~U[2024-06-03 18:22:06.769036Z], 94, "generator"]

18:22:06.781 [debug] QUERY OK source="rule_parts" db=4.7ms queue=0.8ms idle=45.4ms
INSERT INTO "rule_parts" ("block","arguments","updated_at","rule_id","verb") VALUES ($1,$2,$3,$4,$5) RETURNING "id" ["forall", %{object: "var(:price)", predicate: :price, subject: "var(:item)"}, ~U[2024-06-03 18:22:06.776236Z], 94, "has"]

18:22:06.789 [debug] QUERY OK source="rule_parts" db=6.4ms queue=0.9ms idle=51.2ms
INSERT INTO "rule_parts" ("block","arguments","updated_at","rule_id","verb") VALUES ($1,$2,$3,$4,$5) RETURNING "id" ["forall", %{object: "var(:quantity)", predicate: :quantity, subject: "var(:item)"}, ~U[2024-06-03 18:22:06.782034Z], 94, "has"]

18:22:06.798 [debug] QUERY OK source="rule_parts" db=7.4ms queue=1.2ms idle=58.8ms
INSERT INTO "rule_parts" ("block","arguments","updated_at","rule_id","verb") VALUES ($1,$2,$3,$4,$5) RETURNING "id" ["forall", %{object: "var(:discount)", predicate: :discount, subject: "var(:item)"}, ~U[2024-06-03 18:22:06.789686Z], 94, "has"]

18:22:06.807 [debug] QUERY OK source="rule_parts" db=7.2ms queue=1.4ms idle=67.9ms
INSERT INTO "rule_parts" ("block","arguments","updated_at","order","rule_id","verb") VALUES ($1,$2,$3,$4,$5,$6) RETURNING "id" ["forall", %{name: :base_total, value: "&(&1[:price] * &1[:quantity])", eval: "dune"}, ~U[2024-06-03 18:22:06.798702Z], 0, 94, "assign"]

18:22:06.829 [debug] QUERY OK source="rule_parts" db=4.4ms queue=2.9ms idle=91.4ms
SELECT r0."id", r0."rule_id", r0."block", r0."verb", r0."arguments", r0."order", r0."inserted_at", r0."updated_at" FROM "rule_parts" AS r0 WHERE ((r0."rule_id" = $1) AND (r0."verb" = $2)) [94, "assign"]

18:22:06.840 [debug] QUERY OK source="rule_parts" db=5.8ms queue=0.8ms idle=103.0ms
INSERT INTO "rule_parts" ("block","arguments","updated_at","order","rule_id","verb") VALUES ($1,$2,$3,$4,$5,$6) RETURNING "id" ["forall", %{name: :discounted_total, value: "&(&1[:base_total]) * &1[:discount]", eval: "dune"}, ~U[2024-06-03 18:22:06.833850Z], 0, 94, "assign"]

18:22:06.842 [debug] QUERY OK source="rule_parts" db=1.2ms idle=109.8ms
SELECT r0."id", r0."rule_id", r0."block", r0."verb", r0."arguments", r0."order", r0."inserted_at", r0."updated_at" FROM "rule_parts" AS r0 WHERE ((r0."rule_id" = $1) AND (r0."verb" = $2)) [94, "assign"]

18:22:06.851 [debug] QUERY OK source="rule_parts" db=1.1ms queue=1.1ms idle=107.1ms
SELECT r0."id", r0."rule_id", r0."block", r0."verb", r0."arguments", r0."order", r0."inserted_at", r0."updated_at" FROM "rule_parts" AS r0 WHERE (r0."id" = $1) [579]

18:22:06.857 [debug] QUERY OK source="rule_parts" db=5.8ms queue=0.4ms idle=84.2ms
UPDATE "rule_parts" SET "updated_at" = $1, "order" = $2 WHERE "id" = $3 [~U[2024-06-03 18:22:06.843729Z], 3, 579]

18:22:06.859 [debug] QUERY OK source="rule_parts" db=0.9ms idle=81.9ms
SELECT r0."id", r0."rule_id", r0."block", r0."verb", r0."arguments", r0."order", r0."inserted_at", r0."updated_at" FROM "rule_parts" AS r0 WHERE (r0."id" = $1) [578]

18:22:06.864 [debug] QUERY OK source="rule_parts" db=5.2ms queue=0.3ms idle=77.3ms
UPDATE "rule_parts" SET "updated_at" = $1, "order" = $2 WHERE "id" = $3 [~U[2024-06-03 18:22:06.858008Z], 1, 578]

18:22:06.891 [debug] QUERY OK source="rule" db=4.6ms queue=0.6ms idle=96.5ms
SELECT r0."id" FROM "rule" AS r0 WHERE (r0."active" = TRUE) AND (r0."valid_from" <= $1) AND ((r0."valid_to" IS NULL) OR (r0."valid_to" >= $2)) [~U[2024-06-03 18:22:06Z], ~U[2024-06-03 18:22:06Z]]

18:22:06.892 [debug] QUERY OK source="rule_parts" db=0.3ms queue=0.2ms idle=93.0ms
SELECT r0."id", r0."rule_id", r0."block", r0."verb", r0."arguments", r0."order", r0."inserted_at", r0."updated_at" FROM "rule_parts" AS r0 WHERE (r0."rule_id" = $1) [75]

18:22:06.957 [debug] QUERY OK source="rule_parts" db=1.6ms idle=148.1ms
SELECT r0."id", r0."rule_id", r0."block", r0."verb", r0."arguments", r0."order", r0."inserted_at", r0."updated_at" FROM "rule_parts" AS r0 WHERE (r0."rule_id" = $1) [76]

18:22:06.959 [debug] QUERY OK source="rule_parts" db=0.5ms idle=129.2ms
SELECT r0."id", r0."rule_id", r0."block", r0."verb", r0."arguments", r0."order", r0."inserted_at", r0."updated_at" FROM "rule_parts" AS r0 WHERE (r0."rule_id" = $1) [92]

18:22:06.960 [debug] QUERY OK source="rule_parts" db=0.4ms idle=119.9ms
SELECT r0."id", r0."rule_id", r0."block", r0."verb", r0."arguments", r0."order", r0."inserted_at", r0."updated_at" FROM "rule_parts" AS r0 WHERE (r0."rule_id" = $1) [93]
#Wongi.Engine.Rete<
  overlay: %Wongi.Engine.Overlay{
    wmes: MapSet.new([WME.new(:item, :quantity, 2), WME.new(:item, :price, 10),
     WME.new(:item, :base_total, 20), WME.new(:item, :discount, 0.23),
     WME.new(:item, :discount, 0.5),
     WME.new(:item, :discounted_total, 4.6000000000000005),
     WME.new(:item, :discounted_total, 10.0)]),
    indexes: %{
      [:object] => %Wongi.Engine.AlphaIndex{
        fields: [:object],
        entries: %{
          [2] => MapSet.new([WME.new(:item, :quantity, 2)]),
          ~c"\n" => MapSet.new([WME.new(:item, :price, 10)]),
          [20] => MapSet.new([WME.new(:item, :base_total, 20)]),
          [0.23] => MapSet.new([WME.new(:item, :discount, 0.23)]),
          [0.5] => MapSet.new([WME.new(:item, :discount, 0.5)]),
          [4.6000000000000005] => MapSet.new([WME.new(:item, :discounted_total, 4.6000000000000005)]),
          [10.0] => MapSet.new([WME.new(:item, :discounted_total, 10.0)])
        }
      },
      [:predicate] => %Wongi.Engine.AlphaIndex{
        fields: [:predicate],
        entries: %{
          [:base_total] => MapSet.new([WME.new(:item, :base_total, 20)]),
          [:discount] => MapSet.new([WME.new(:item, :discount, 0.23),
           WME.new(:item, :discount, 0.5)]),
          [:discounted_total] => MapSet.new([WME.new(:item, :discounted_total, 4.6000000000000005),
           WME.new(:item, :discounted_total, 10.0)]),
          [:price] => MapSet.new([WME.new(:item, :price, 10)]),
          [:quantity] => MapSet.new([WME.new(:item, :quantity, 2)])
        }
      },
      [:predicate, :object] => %Wongi.Engine.AlphaIndex{
        fields: [:predicate, :object],
        entries: %{
          [:base_total, 20] => MapSet.new([WME.new(:item, :base_total, 20)]),
          [:discount, 0.23] => MapSet.new([WME.new(:item, :discount, 0.23)]),
          [:discount, 0.5] => MapSet.new([WME.new(:item, :discount, 0.5)]),
          [:discounted_total, 4.6000000000000005] => MapSet.new([WME.new(:item, :discounted_total, 4.6000000000000005)]),
          [:discounted_total, 10.0] => MapSet.new([WME.new(:item, :discounted_total, 10.0)]),
          [:price, 10] => MapSet.new([WME.new(:item, :price, 10)]),
          [:quantity, 2] => MapSet.new([WME.new(:item, :quantity, 2)])
        }
      },
      [:subject] => %Wongi.Engine.AlphaIndex{
        fields: [:subject],
        entries: %{
          [:item] => MapSet.new([WME.new(:item, :quantity, 2),
           WME.new(:item, :price, 10), WME.new(:item, :base_total, 20),
           WME.new(:item, :discount, 0.23), WME.new(:item, :discount, 0.5),
           WME.new(:item, :discounted_total, 4.6000000000000005),
           WME.new(:item, :discounted_total, 10.0)])
        }
      },
      [:subject, :object] => %Wongi.Engine.AlphaIndex{
        fields: [:subject, :object],
        entries: %{
          [:item, 2] => MapSet.new([WME.new(:item, :quantity, 2)]),
          [:item, 10] => MapSet.new([WME.new(:item, :price, 10)]),
          [:item, 20] => MapSet.new([WME.new(:item, :base_total, 20)]),
          [:item, 0.23] => MapSet.new([WME.new(:item, :discount, 0.23)]),
          [:item, 0.5] => MapSet.new([WME.new(:item, :discount, 0.5)]),
          [:item, 4.6000000000000005] => MapSet.new([WME.new(:item, :discounted_total, 4.6000000000000005)]),
          [:item, 10.0] => MapSet.new([WME.new(:item, :discounted_total, 10.0)])
        }
      },
      [:subject, :predicate] => %Wongi.Engine.AlphaIndex{
        fields: [:subject, :predicate],
        entries: %{
          [:item, :base_total] => MapSet.new([WME.new(:item, :base_total, 20)]),
          [:item, :discount] => MapSet.new([WME.new(:item, :discount, 0.23),
           WME.new(:item, :discount, 0.5)]),
          [:item, :discounted_total] => MapSet.new([WME.new(:item, :discounted_total, 4.6000000000000005),
           WME.new(:item, :discounted_total, 10.0)]),
          [:item, :price] => MapSet.new([WME.new(:item, :price, 10)]),
          [:item, :quantity] => MapSet.new([WME.new(:item, :quantity, 2)])
        }
      }
    },
    manual: MapSet.new([WME.new(:item, :quantity, 2),
     WME.new(:item, :price, 10), WME.new(:item, :discount, 0.23),
     WME.new(:item, :discount, 0.5)]),
    tokens: %{
      #Reference<0.2554059997.3201564676.176675> => MapSet.new([
        %Wongi.Engine.Token{
          ref: #Reference<0.2554059997.3201564677.178602>,
          node_ref: #Reference<0.2554059997.3201564676.176675>,
          parents: MapSet.new([
            %Wongi.Engine.Token{
              ref: #Reference<0.2554059997.3201564677.178601>,
              node_ref: #Reference<0.2554059997.3201564677.178472>,
              parents: MapSet.new([
                %Wongi.Engine.Token{
                  ref: #Reference<0.2554059997.3201564677.178600>,
                  node_ref: #Reference<0.2554059997.3201564677.178467>,
                  parents: MapSet.new([
                    %Wongi.Engine.Token{
                      ref: #Reference<0.2554059997.3201564677.178599>,
                      node_ref: #Reference<0.2554059997.3201564677.178458>,
                      parents: MapSet.new([
                        %Wongi.Engine.Token{
                          ref: #Reference<0.2554059997.3201564677.178598>,
                          node_ref: #Reference<0.2554059997.3201564677.178457>,
                          parents: MapSet.new([
                            %Wongi.Engine.Token{
                              ref: #Reference<0.2554059997.3201564677.178448>,
                              node_ref: #Reference<0.2554059997.3201564677.178435>,
                              parents: MapSet.new([]),
                              wme: nil,
                              assignments: %{}
                            }
                          ]),
                          wme: WME.new(:item, :price, 10),
                          assignments: %{item: :item, price: 10}
                        }
                      ]),
                      wme: WME.new(:item, :quantity, 2),
                      assignments: %{quantity: 2}
                    }
                  ]),
                  wme: WME.new(:item, :discount, 0.5),
                  assignments: %{discount: 0.5}
                }
              ]),
              wme: nil,
              assignments: %{base_total: 20}
            }
          ]),
          wme: nil,
          assignments: %{discounted_total: 10.0}
        },
        %Wongi.Engine.Token{
          ref: #Reference<0.2554059997.3201564677.178616>,
          node_ref: #Reference<0.2554059997.3201564676.176675>,
          parents: MapSet.new([
            %Wongi.Engine.Token{
              ref: #Reference<0.2554059997.3201564677.178615>,
              node_ref: #Reference<0.2554059997.3201564677.178472>,
              parents: MapSet.new([
                %Wongi.Engine.Token{
                  ref: #Reference<0.2554059997.3201564677.178614>,
                  node_ref: #Reference<0.2554059997.3201564677.178467>,
                  parents: MapSet.new([
                    %Wongi.Engine.Token{
                      ref: #Reference<0.2554059997.3201564677.178599>,
                      node_ref: #Reference<0.2554059997.3201564677.178458>,
                      parents: MapSet.new([
                        %Wongi.Engine.Token{
                          ref: #Reference<0.2554059997.3201564677.178598>,
                          node_ref: #Reference<0.2554059997.3201564677.178457>,
                          parents: MapSet.new([
                            %Wongi.Engine.Token{
                              ref: #Reference<0.2554059997.3201564677.178448>,
                              node_ref: #Reference<0.2554059997.3201564677.178435>,
                              parents: MapSet.new([]),
                              wme: nil,
                              assignments: %{}
                            }
                          ]),
                          wme: WME.new(:item, :price, 10),
                          assignments: %{item: :item, price: 10}
                        }
                      ]),
                      wme: WME.new(:item, :quantity, 2),
                      assignments: %{quantity: 2}
                    }
                  ]),
                  wme: WME.new(:item, :discount, 0.23),
                  assignments: %{discount: 0.23}
                }
              ]),
              wme: nil,
              assignments: %{base_total: 20}
            }
          ]),
          wme: nil,
          assignments: %{discounted_total: 4.6000000000000005}
        }
      ]),
      #Reference<0.2554059997.3201564677.178418> => MapSet.new([
        %Wongi.Engine.Token{
          ref: #Reference<0.2554059997.3201564677.178613>,
          node_ref: #Reference<0.2554059997.3201564677.178418>,
          parents: MapSet.new([
            %Wongi.Engine.Token{
              ref: #Reference<0.2554059997.3201564677.178601>,
              node_ref: #Reference<0.2554059997.3201564677.178472>,
              parents: MapSet.new([
                %Wongi.Engine.Token{
                  ref: #Reference<0.2554059997.3201564677.178600>,
                  node_ref: #Reference<0.2554059997.3201564677.178467>,
                  parents: MapSet.new([
                    %Wongi.Engine.Token{
                      ref: #Reference<0.2554059997.3201564677.178599>,
                      node_ref: #Reference<0.2554059997.3201564677.178458>,
                      parents: MapSet.new([
                        %Wongi.Engine.Token{
                          ref: #Reference<0.2554059997.3201564677.178598>,
                          node_ref: #Reference<0.2554059997.3201564677.178457>,
                          parents: MapSet.new([
                            %Wongi.Engine.Token{
                              ref: #Reference<0.2554059997.3201564677.178448>,
                              node_ref: #Reference<0.2554059997.3201564677.178435>,
                              parents: MapSet.new([]),
                              wme: nil,
                              assignments: %{}
                            }
                          ]),
                          wme: WME.new(:item, :price, 10),
                          assignments: %{item: :item, price: 10}
                        }
                      ]),
                      wme: WME.new(:item, :quantity, 2),
                      assignments: %{quantity: 2}
                    }
                  ]),
                  wme: WME.new(:item, :discount, 0.5),
                  assignments: %{discount: 0.5}
                }
              ]),
              wme: nil,
              assignments: %{base_total: 20}
            }
          ]),
          wme: nil,
          assignments: %{discounted_total: 10.0}
        },
        %Wongi.Engine.Token{
          ref: #Reference<0.2554059997.3201564677.178619>,
          node_ref: #Reference<0.2554059997.3201564677.178418>,
          parents: MapSet.new([
            %Wongi.Engine.Token{
              ref: #Reference<0.2554059997.3201564677.178615>,
              node_ref: #Reference<0.2554059997.3201564677.178472>,
              parents: MapSet.new([
                %Wongi.Engine.Token{
                  ref: #Reference<0.2554059997.3201564677.178614>,
                  node_ref: #Reference<0.2554059997.3201564677.178467>,
                  parents: MapSet.new([
                    %Wongi.Engine.Token{
                      ref: #Reference<0.2554059997.3201564677.178599>,
                      node_ref: #Reference<0.2554059997.3201564677.178458>,
                      parents: MapSet.new([
                        %Wongi.Engine.Token{
                          ref: #Reference<0.2554059997.3201564677.178598>,
                          node_ref: #Reference<0.2554059997.3201564677.178457>,
                          parents: MapSet.new([
                            %Wongi.Engine.Token{
                              ref: #Reference<0.2554059997.3201564677.178448>,
                              node_ref: #Reference<0.2554059997.3201564677.178435>,
                              parents: MapSet.new([]),
                              wme: nil,
                              assignments: %{}
                            }
                          ]),
                          wme: WME.new(:item, :price, 10),
                          assignments: %{item: :item, price: 10}
                        }
                      ]),
                      wme: WME.new(:item, :quantity, 2),
                      assignments: %{quantity: 2}
                    }
                  ]),
                  wme: WME.new(:item, :discount, 0.23),
                  assignments: %{discount: 0.23}
                }
              ]),
              wme: nil,
              assignments: %{base_total: 20}
            }
          ]),
          wme: nil,
          assignments: %{discounted_total: 4.6000000000000005}
        }
      ]),
      #Reference<0.2554059997.3201564677.178435> => MapSet.new([
        %Wongi.Engine.Token{
          ref: #Reference<0.2554059997.3201564677.178448>,
          node_ref: #Reference<0.2554059997.3201564677.178435>,
          parents: MapSet.new([]),
          wme: nil,
          assignments: %{}
        }
      ]),
      #Reference<0.2554059997.3201564677.178457> => MapSet.new([
        %Wongi.Engine.Token{
          ref: #Reference<0.2554059997.3201564677.178598>,
          node_ref: #Reference<0.2554059997.3201564677.178457>,
          parents: MapSet.new([
            %Wongi.Engine.Token{
              ref: #Reference<0.2554059997.3201564677.178448>,
              node_ref: #Reference<0.2554059997.3201564677.178435>,
              parents: MapSet.new([]),
              wme: nil,
              assignments: %{}
            }
          ]),
          wme: WME.new(:item, :price, 10),
          assignments: %{item: :item, price: 10}
        }
      ]),
      #Reference<0.2554059997.3201564677.178458> => MapSet.new([
        %Wongi.Engine.Token{
          ref: #Reference<0.2554059997.3201564677.178599>,
          node_ref: #Reference<0.2554059997.3201564677.178458>,
          parents: MapSet.new([
            %Wongi.Engine.Token{
              ref: #Reference<0.2554059997.3201564677.178598>,
              node_ref: #Reference<0.2554059997.3201564677.178457>,
              parents: MapSet.new([
                %Wongi.Engine.Token{
                  ref: #Reference<0.2554059997.3201564677.178448>,
                  node_ref: #Reference<0.2554059997.3201564677.178435>,
                  parents: MapSet.new([]),
                  wme: nil,
                  assignments: %{}
                }
              ]),
              wme: WME.new(:item, :price, 10),
              assignments: %{item: :item, price: 10}
            }
          ]),
          wme: WME.new(:item, :quantity, 2),
          assignments: %{quantity: 2}
        }
      ]),
      #Reference<0.2554059997.3201564677.178467> => MapSet.new([
        %Wongi.Engine.Token{
          ref: #Reference<0.2554059997.3201564677.178600>,
          node_ref: #Reference<0.2554059997.3201564677.178467>,
          parents: MapSet.new([
            %Wongi.Engine.Token{
              ref: #Reference<0.2554059997.3201564677.178599>,
              node_ref: #Reference<0.2554059997.3201564677.178458>,
              parents: MapSet.new([
                %Wongi.Engine.Token{
                  ref: #Reference<0.2554059997.3201564677.178598>,
                  node_ref: #Reference<0.2554059997.3201564677.178457>,
                  parents: MapSet.new([
                    %Wongi.Engine.Token{
                      ref: #Reference<0.2554059997.3201564677.178448>,
                      node_ref: #Reference<0.2554059997.3201564677.178435>,
                      parents: MapSet.new([]),
                      wme: nil,
                      assignments: %{}
                    }
                  ]),
                  wme: WME.new(:item, :price, 10),
                  assignments: %{item: :item, price: 10}
                }
              ]),
              wme: WME.new(:item, :quantity, 2),
              assignments: %{quantity: 2}
            }
          ]),
          wme: WME.new(:item, :discount, 0.5),
          assignments: %{discount: 0.5}
        },
        %Wongi.Engine.Token{
          ref: #Reference<0.2554059997.3201564677.178614>,
          node_ref: #Reference<0.2554059997.3201564677.178467>,
          parents: MapSet.new([
            %Wongi.Engine.Token{
              ref: #Reference<0.2554059997.3201564677.178599>,
              node_ref: #Reference<0.2554059997.3201564677.178458>,
              parents: MapSet.new([
                %Wongi.Engine.Token{
                  ref: #Reference<0.2554059997.3201564677.178598>,
                  node_ref: #Reference<0.2554059997.3201564677.178457>,
                  parents: MapSet.new([
                    %Wongi.Engine.Token{
                      ref: #Reference<0.2554059997.3201564677.178448>,
                      node_ref: #Reference<0.2554059997.3201564677.178435>,
                      parents: MapSet.new([]),
                      wme: nil,
                      assignments: %{}
                    }
                  ]),
                  wme: WME.new(:item, :price, 10),
                  assignments: %{item: :item, price: 10}
                }
              ]),
              wme: WME.new(:item, :quantity, 2),
              assignments: %{quantity: 2}
            }
          ]),
          wme: WME.new(:item, :discount, 0.23),
          assignments: %{discount: 0.23}
        }
      ]),
      #Reference<0.2554059997.3201564677.178472> => MapSet.new([
        %Wongi.Engine.Token{
          ref: #Reference<0.2554059997.3201564677.178601>,
          node_ref: #Reference<0.2554059997.3201564677.178472>,
          parents: MapSet.new([
            %Wongi.Engine.Token{
              ref: #Reference<0.2554059997.3201564677.178600>,
              node_ref: #Reference<0.2554059997.3201564677.178467>,
              parents: MapSet.new([
                %Wongi.Engine.Token{
                  ref: #Reference<0.2554059997.3201564677.178599>,
                  node_ref: #Reference<0.2554059997.3201564677.178458>,
                  parents: MapSet.new([
                    %Wongi.Engine.Token{
                      ref: #Reference<0.2554059997.3201564677.178598>,
                      node_ref: #Reference<0.2554059997.3201564677.178457>,
                      parents: MapSet.new([
                        %Wongi.Engine.Token{
                          ref: #Reference<0.2554059997.3201564677.178448>,
                          node_ref: #Reference<0.2554059997.3201564677.178435>,
                          parents: MapSet.new([]),
                          wme: nil,
                          assignments: %{}
                        }
                      ]),
                      wme: WME.new(:item, :price, 10),
                      assignments: %{item: :item, price: 10}
                    }
                  ]),
                  wme: WME.new(:item, :quantity, 2),
                  assignments: %{quantity: 2}
                }
              ]),
              wme: WME.new(:item, :discount, 0.5),
              assignments: %{discount: 0.5}
            }
          ]),
          wme: nil,
          assignments: %{base_total: 20}
        },
        %Wongi.Engine.Token{
          ref: #Reference<0.2554059997.3201564677.178615>,
          node_ref: #Reference<0.2554059997.3201564677.178472>,
          parents: MapSet.new([
            %Wongi.Engine.Token{
              ref: #Reference<0.2554059997.3201564677.178614>,
              node_ref: #Reference<0.2554059997.3201564677.178467>,
              parents: MapSet.new([
                %Wongi.Engine.Token{
                  ref: #Reference<0.2554059997.3201564677.178599>,
                  node_ref: #Reference<0.2554059997.3201564677.178458>,
                  parents: MapSet.new([
                    %Wongi.Engine.Token{
                      ref: #Reference<0.2554059997.3201564677.178598>,
                      node_ref: #Reference<0.2554059997.3201564677.178457>,
                      parents: MapSet.new([
                        %Wongi.Engine.Token{
                          ref: #Reference<0.2554059997.3201564677.178448>,
                          node_ref: #Reference<0.2554059997.3201564677.178435>,
                          parents: MapSet.new([]),
                          wme: nil,
                          assignments: %{}
                        }
                      ]),
                      wme: WME.new(:item, :price, 10),
                      assignments: %{item: :item, price: 10}
                    }
                  ]),
                  wme: WME.new(:item, :quantity, 2),
                  assignments: %{quantity: 2}
                }
              ]),
              wme: WME.new(:item, :discount, 0.23),
              assignments: %{discount: 0.23}
            }
          ]),
          wme: nil,
          assignments: %{base_total: 20}
        }
      ]),
      #Reference<0.2554059997.3201564677.178521> => MapSet.new([
        %Wongi.Engine.Token{
          ref: #Reference<0.2554059997.3201564677.178612>,
          node_ref: #Reference<0.2554059997.3201564677.178521>,
          parents: MapSet.new([
            %Wongi.Engine.Token{
              ref: #Reference<0.2554059997.3201564677.178601>,
              node_ref: #Reference<0.2554059997.3201564677.178472>,
              parents: MapSet.new([
                %Wongi.Engine.Token{
                  ref: #Reference<0.2554059997.3201564677.178600>,
                  node_ref: #Reference<0.2554059997.3201564677.178467>,
                  parents: MapSet.new([
                    %Wongi.Engine.Token{
                      ref: #Reference<0.2554059997.3201564677.178599>,
                      node_ref: #Reference<0.2554059997.3201564677.178458>,
                      parents: MapSet.new([
                        %Wongi.Engine.Token{
                          ref: #Reference<0.2554059997.3201564677.178598>,
                          node_ref: #Reference<0.2554059997.3201564677.178457>,
                          parents: MapSet.new([
                            %Wongi.Engine.Token{
                              ref: #Reference<0.2554059997.3201564677.178448>,
                              node_ref: #Reference<0.2554059997.3201564677.178435>,
                              parents: MapSet.new([]),
                              wme: nil,
                              assignments: %{}
                            }
                          ]),
                          wme: WME.new(:item, :price, 10),
                          assignments: %{item: :item, price: 10}
                        }
                      ]),
                      wme: WME.new(:item, :quantity, 2),
                      assignments: %{quantity: 2}
                    }
                  ]),
                  wme: WME.new(:item, :discount, 0.5),
                  assignments: %{discount: 0.5}
                }
              ]),
              wme: nil,
              assignments: %{base_total: 20}
            }
          ]),
          wme: nil,
          assignments: %{discounted_total: 10.0}
        },
        %Wongi.Engine.Token{
          ref: #Reference<0.2554059997.3201564677.178618>,
          node_ref: #Reference<0.2554059997.3201564677.178521>,
          parents: MapSet.new([
            %Wongi.Engine.Token{
              ref: #Reference<0.2554059997.3201564677.178615>,
              node_ref: #Reference<0.2554059997.3201564677.178472>,
              parents: MapSet.new([
                %Wongi.Engine.Token{
                  ref: #Reference<0.2554059997.3201564677.178614>,
                  node_ref: #Reference<0.2554059997.3201564677.178467>,
                  parents: MapSet.new([
                    %Wongi.Engine.Token{
                      ref: #Reference<0.2554059997.3201564677.178599>,
                      node_ref: #Reference<0.2554059997.3201564677.178458>,
                      parents: MapSet.new([
                        %Wongi.Engine.Token{
                          ref: #Reference<0.2554059997.3201564677.178598>,
                          node_ref: #Reference<0.2554059997.3201564677.178457>,
                          parents: MapSet.new([
                            %Wongi.Engine.Token{
                              ref: #Reference<0.2554059997.3201564677.178448>,
                              node_ref: #Reference<0.2554059997.3201564677.178435>,
                              parents: MapSet.new([]),
                              wme: nil,
                              assignments: %{}
                            }
                          ]),
                          wme: WME.new(:item, :price, 10),
                          assignments: %{item: :item, price: 10}
                        }
                      ]),
                      wme: WME.new(:item, :quantity, 2),
                      assignments: %{quantity: 2}
                    }
                  ]),
                  wme: WME.new(:item, :discount, 0.23),
                  assignments: %{discount: 0.23}
                }
              ]),
              wme: nil,
              assignments: %{base_total: 20}
            }
          ]),
          wme: nil,
          assignments: %{discounted_total: 4.6000000000000005}
        }
      ]),
      #Reference<0.2554059997.3201564677.178566> => MapSet.new([
        %Wongi.Engine.Token{
          ref: #Reference<0.2554059997.3201564677.178611>,
          node_ref: #Reference<0.2554059997.3201564677.178566>,
          parents: MapSet.new([
            %Wongi.Engine.Token{
              ref: #Reference<0.2554059997.3201564677.178601>,
              node_ref: #Reference<0.2554059997.3201564677.178472>,
              parents: MapSet.new([
                %Wongi.Engine.Token{
                  ref: #Reference<0.2554059997.3201564677.178600>,
                  node_ref: #Reference<0.2554059997.3201564677.178467>,
                  parents: MapSet.new([
                    %Wongi.Engine.Token{
                      ref: #Reference<0.2554059997.3201564677.178599>,
                      node_ref: #Reference<0.2554059997.3201564677.178458>,
                      parents: MapSet.new([
                        %Wongi.Engine.Token{
                          ref: #Reference<0.2554059997.3201564677.178598>,
                          node_ref: #Reference<0.2554059997.3201564677.178457>,
                          parents: MapSet.new([
                            %Wongi.Engine.Token{
                              ref: #Reference<0.2554059997.3201564677.178448>,
                              node_ref: #Reference<0.2554059997.3201564677.178435>,
                              parents: MapSet.new([]),
                              wme: nil,
                              assignments: %{}
                            }
                          ]),
                          wme: WME.new(:item, :price, 10),
                          assignments: %{item: :item, price: 10}
                        }
                      ]),
                      wme: WME.new(:item, :quantity, 2),
                      assignments: %{quantity: 2}
                    }
                  ]),
                  wme: WME.new(:item, :discount, 0.5),
                  assignments: %{discount: 0.5}
                }
              ]),
              wme: nil,
              assignments: %{base_total: 20}
            }
          ]),
          wme: nil,
          assignments: %{discounted_total: 10.0}
        },
        %Wongi.Engine.Token{
          ref: #Reference<0.2554059997.3201564677.178617>,
          node_ref: #Reference<0.2554059997.3201564677.178566>,
          parents: MapSet.new([
            %Wongi.Engine.Token{
              ref: #Reference<0.2554059997.3201564677.178615>,
              node_ref: #Reference<0.2554059997.3201564677.178472>,
              parents: MapSet.new([
                %Wongi.Engine.Token{
                  ref: #Reference<0.2554059997.3201564677.178614>,
                  node_ref: #Reference<0.2554059997.3201564677.178467>,
                  parents: MapSet.new([
                    %Wongi.Engine.Token{
                      ref: #Reference<0.2554059997.3201564677.178599>,
                      node_ref: #Reference<0.2554059997.3201564677.178458>,
                      parents: MapSet.new([
                        %Wongi.Engine.Token{
                          ref: #Reference<0.2554059997.3201564677.178598>,
                          node_ref: #Reference<0.2554059997.3201564677.178457>,
                          parents: MapSet.new([
                            %Wongi.Engine.Token{
                              ref: #Reference<0.2554059997.3201564677.178448>,
                              node_ref: #Reference<0.2554059997.3201564677.178435>,
                              parents: MapSet.new([]),
                              wme: nil,
                              assignments: %{}
                            }
                          ]),
                          wme: WME.new(:item, :price, 10),
                          assignments: %{item: :item, price: 10}
                        }
                      ]),
                      wme: WME.new(:item, :quantity, 2),
                      assignments: %{quantity: 2}
                    }
                  ]),
                  wme: WME.new(:item, :discount, 0.23),
                  assignments: %{discount: 0.23}
                }
              ]),
              wme: nil,
              assignments: %{base_total: 20}
            }
          ]),
          wme: nil,
          assignments: %{discounted_total: 4.6000000000000005}
        }
      ])
    },
    neg_join_results: %Wongi.Engine.Overlay.JoinResults{
      by_wme: %{},
      by_token: %{}
    },
    generation_tracker: %Wongi.Engine.Overlay.GenerationTracker{
      by_wme: %{
        WME.new(:item, :base_total, 20) => MapSet.new([
          %Wongi.Engine.Token{
            ref: #Reference<0.2554059997.3201564677.178602>,
            node_ref: #Reference<0.2554059997.3201564676.176675>,
            parents: MapSet.new([
              %Wongi.Engine.Token{
                ref: #Reference<0.2554059997.3201564677.178601>,
                node_ref: #Reference<0.2554059997.3201564677.178472>,
                parents: MapSet.new([
                  %Wongi.Engine.Token{
                    ref: #Reference<0.2554059997.3201564677.178600>,
                    node_ref: #Reference<0.2554059997.3201564677.178467>,
                    parents: MapSet.new([
                      %Wongi.Engine.Token{
                        ref: #Reference<0.2554059997.3201564677.178599>,
                        node_ref: #Reference<0.2554059997.3201564677.178458>,
                        parents: MapSet.new([
                          %Wongi.Engine.Token{
                            ref: #Reference<0.2554059997.3201564677.178598>,
                            node_ref: #Reference<0.2554059997.3201564677.178457>,
                            parents: MapSet.new([
                              %Wongi.Engine.Token{
                                ref: #Reference<0.2554059997.3201564677.178448>,
                                node_ref: #Reference<0.2554059997.3201564677.178435>,
                                parents: MapSet.new([]),
                                wme: nil,
                                assignments: %{}
                              }
                            ]),
                            wme: WME.new(:item, :price, 10),
                            assignments: %{item: :item, price: 10}
                          }
                        ]),
                        wme: WME.new(:item, :quantity, 2),
                        assignments: %{quantity: 2}
                      }
                    ]),
                    wme: WME.new(:item, :discount, 0.5),
                    assignments: %{discount: 0.5}
                  }
                ]),
                wme: nil,
                assignments: %{base_total: 20}
              }
            ]),
            wme: nil,
            assignments: %{discounted_total: 10.0}
          },
          %Wongi.Engine.Token{
            ref: #Reference<0.2554059997.3201564677.178611>,
            node_ref: #Reference<0.2554059997.3201564677.178566>,
            parents: MapSet.new([
              %Wongi.Engine.Token{
                ref: #Reference<0.2554059997.3201564677.178601>,
                node_ref: #Reference<0.2554059997.3201564677.178472>,
                parents: MapSet.new([
                  %Wongi.Engine.Token{
                    ref: #Reference<0.2554059997.3201564677.178600>,
                    node_ref: #Reference<0.2554059997.3201564677.178467>,
                    parents: MapSet.new([
                      %Wongi.Engine.Token{
                        ref: #Reference<0.2554059997.3201564677.178599>,
                        node_ref: #Reference<0.2554059997.3201564677.178458>,
                        parents: MapSet.new([
                          %Wongi.Engine.Token{
                            ref: #Reference<0.2554059997.3201564677.178598>,
                            node_ref: #Reference<0.2554059997.3201564677.178457>,
                            parents: MapSet.new([
                              %Wongi.Engine.Token{
                                ref: #Reference<0.2554059997.3201564677.178448>,
                                node_ref: #Reference<0.2554059997.3201564677.178435>,
                                parents: MapSet.new([]),
                                wme: nil,
                                assignments: %{}
                              }
                            ]),
                            wme: WME.new(:item, :price, 10),
                            assignments: %{item: :item, price: 10}
                          }
                        ]),
                        wme: WME.new(:item, :quantity, 2),
                        assignments: %{quantity: 2}
                      }
                    ]),
                    wme: WME.new(:item, :discount, 0.5),
                    assignments: %{discount: 0.5}
                  }
                ]),
                wme: nil,
                assignments: %{base_total: 20}
              }
            ]),
            wme: nil,
            assignments: %{discounted_total: 10.0}
          },
          %Wongi.Engine.Token{
            ref: #Reference<0.2554059997.3201564677.178612>,
            node_ref: #Reference<0.2554059997.3201564677.178521>,
            parents: MapSet.new([
              %Wongi.Engine.Token{
                ref: #Reference<0.2554059997.3201564677.178601>,
                node_ref: #Reference<0.2554059997.3201564677.178472>,
                parents: MapSet.new([
                  %Wongi.Engine.Token{
                    ref: #Reference<0.2554059997.3201564677.178600>,
                    node_ref: #Reference<0.2554059997.3201564677.178467>,
                    parents: MapSet.new([
                      %Wongi.Engine.Token{
                        ref: #Reference<0.2554059997.3201564677.178599>,
                        node_ref: #Reference<0.2554059997.3201564677.178458>,
                        parents: MapSet.new([
                          %Wongi.Engine.Token{
                            ref: #Reference<0.2554059997.3201564677.178598>,
                            node_ref: #Reference<0.2554059997.3201564677.178457>,
                            parents: MapSet.new([
                              %Wongi.Engine.Token{
                                ref: #Reference<0.2554059997.3201564677.178448>,
                                node_ref: #Reference<0.2554059997.3201564677.178435>,
                                parents: MapSet.new([]),
                                wme: nil,
                                assignments: %{}
                              }
                            ]),
                            wme: WME.new(:item, :price, 10),
                            assignments: %{item: :item, price: 10}
                          }
                        ]),
                        wme: WME.new(:item, :quantity, 2),
                        assignments: %{quantity: 2}
                      }
                    ]),
                    wme: WME.new(:item, :discount, 0.5),
                    assignments: %{discount: 0.5}
                  }
                ]),
                wme: nil,
                assignments: %{base_total: 20}
              }
            ]),
            wme: nil,
            assignments: %{discounted_total: 10.0}
          },
          %Wongi.Engine.Token{
            ref: #Reference<0.2554059997.3201564677.178613>,
            node_ref: #Reference<0.2554059997.3201564677.178418>,
            parents: MapSet.new([
              %Wongi.Engine.Token{
                ref: #Reference<0.2554059997.3201564677.178601>,
                node_ref: #Reference<0.2554059997.3201564677.178472>,
                parents: MapSet.new([
                  %Wongi.Engine.Token{
                    ref: #Reference<0.2554059997.3201564677.178600>,
                    node_ref: #Reference<0.2554059997.3201564677.178467>,
                    parents: MapSet.new([
                      %Wongi.Engine.Token{
                        ref: #Reference<0.2554059997.3201564677.178599>,
                        node_ref: #Reference<0.2554059997.3201564677.178458>,
                        parents: MapSet.new([
                          %Wongi.Engine.Token{
                            ref: #Reference<0.2554059997.3201564677.178598>,
                            node_ref: #Reference<0.2554059997.3201564677.178457>,
                            parents: MapSet.new([
                              %Wongi.Engine.Token{
                                ref: #Reference<0.2554059997.3201564677.178448>,
                                node_ref: #Reference<0.2554059997.3201564677.178435>,
                                parents: MapSet.new([]),
                                wme: nil,
                                assignments: %{}
                              }
                            ]),
                            wme: WME.new(:item, :price, 10),
                            assignments: %{item: :item, price: 10}
                          }
                        ]),
                        wme: WME.new(:item, :quantity, 2),
                        assignments: %{quantity: 2}
                      }
                    ]),
                    wme: WME.new(:item, :discount, 0.5),
                    assignments: %{discount: 0.5}
                  }
                ]),
                wme: nil,
                assignments: %{base_total: 20}
              }
            ]),
            wme: nil,
            assignments: %{discounted_total: 10.0}
          },
          %Wongi.Engine.Token{
            ref: #Reference<0.2554059997.3201564677.178616>,
            node_ref: #Reference<0.2554059997.3201564676.176675>,
            parents: MapSet.new([
              %Wongi.Engine.Token{
                ref: #Reference<0.2554059997.3201564677.178615>,
                node_ref: #Reference<0.2554059997.3201564677.178472>,
                parents: MapSet.new([
                  %Wongi.Engine.Token{
                    ref: #Reference<0.2554059997.3201564677.178614>,
                    node_ref: #Reference<0.2554059997.3201564677.178467>,
                    parents: MapSet.new([
                      %Wongi.Engine.Token{
                        ref: #Reference<0.2554059997.3201564677.178599>,
                        node_ref: #Reference<0.2554059997.3201564677.178458>,
                        parents: MapSet.new([
                          %Wongi.Engine.Token{
                            ref: #Reference<0.2554059997.3201564677.178598>,
                            node_ref: #Reference<0.2554059997.3201564677.178457>,
                            parents: MapSet.new([
                              %Wongi.Engine.Token{
                                ref: #Reference<0.2554059997.3201564677.178448>,
                                node_ref: #Reference<0.2554059997.3201564677.178435>,
                                parents: MapSet.new([]),
                                wme: nil,
                                assignments: %{}
                              }
                            ]),
                            wme: WME.new(:item, :price, 10),
                            assignments: %{item: :item, price: 10}
                          }
                        ]),
                        wme: WME.new(:item, :quantity, 2),
                        assignments: %{quantity: 2}
                      }
                    ]),
                    wme: WME.new(:item, :discount, 0.23),
                    assignments: %{discount: 0.23}
                  }
                ]),
                wme: nil,
                assignments: %{base_total: 20}
              }
            ]),
            wme: nil,
            assignments: %{discounted_total: 4.6000000000000005}
          },
          %Wongi.Engine.Token{
            ref: #Reference<0.2554059997.3201564677.178617>,
            node_ref: #Reference<0.2554059997.3201564677.178566>,
            parents: MapSet.new([
              %Wongi.Engine.Token{
                ref: #Reference<0.2554059997.3201564677.178615>,
                node_ref: #Reference<0.2554059997.3201564677.178472>,
                parents: MapSet.new([
                  %Wongi.Engine.Token{
                    ref: #Reference<0.2554059997.3201564677.178614>,
                    node_ref: #Reference<0.2554059997.3201564677.178467>,
                    parents: MapSet.new([
                      %Wongi.Engine.Token{
                        ref: #Reference<0.2554059997.3201564677.178599>,
                        node_ref: #Reference<0.2554059997.3201564677.178458>,
                        parents: MapSet.new([
                          %Wongi.Engine.Token{
                            ref: #Reference<0.2554059997.3201564677.178598>,
                            node_ref: #Reference<0.2554059997.3201564677.178457>,
                            parents: MapSet.new([
                              %Wongi.Engine.Token{
                                ref: #Reference<0.2554059997.3201564677.178448>,
                                node_ref: #Reference<0.2554059997.3201564677.178435>,
                                parents: MapSet.new([]),
                                wme: nil,
                                assignments: %{}
                              }
                            ]),
                            wme: WME.new(:item, :price, 10),
                            assignments: %{item: :item, price: 10}
                          }
                        ]),
                        wme: WME.new(:item, :quantity, 2),
                        assignments: %{quantity: 2}
                      }
                    ]),
                    wme: WME.new(:item, :discount, 0.23),
                    assignments: %{discount: 0.23}
                  }
                ]),
                wme: nil,
                assignments: %{base_total: 20}
              }
            ]),
            wme: nil,
            assignments: %{discounted_total: 4.6000000000000005}
          },
          %Wongi.Engine.Token{
            ref: #Reference<0.2554059997.3201564677.178618>,
            node_ref: #Reference<0.2554059997.3201564677.178521>,
            parents: MapSet.new([
              %Wongi.Engine.Token{
                ref: #Reference<0.2554059997.3201564677.178615>,
                node_ref: #Reference<0.2554059997.3201564677.178472>,
                parents: MapSet.new([
                  %Wongi.Engine.Token{
                    ref: #Reference<0.2554059997.3201564677.178614>,
                    node_ref: #Reference<0.2554059997.3201564677.178467>,
                    parents: MapSet.new([
                      %Wongi.Engine.Token{
                        ref: #Reference<0.2554059997.3201564677.178599>,
                        node_ref: #Reference<0.2554059997.3201564677.178458>,
                        parents: MapSet.new([
                          %Wongi.Engine.Token{
                            ref: #Reference<0.2554059997.3201564677.178598>,
                            node_ref: #Reference<0.2554059997.3201564677.178457>,
                            parents: MapSet.new([
                              %Wongi.Engine.Token{
                                ref: #Reference<0.2554059997.3201564677.178448>,
                                node_ref: #Reference<0.2554059997.3201564677.178435>,
                                parents: MapSet.new([]),
                                wme: nil,
                                assignments: %{}
                              }
                            ]),
                            wme: WME.new(:item, :price, 10),
                            assignments: %{item: :item, price: 10}
                          }
                        ]),
                        wme: WME.new(:item, :quantity, 2),
                        assignments: %{quantity: 2}
                      }
                    ]),
                    wme: WME.new(:item, :discount, 0.23),
                    assignments: %{discount: 0.23}
                  }
                ]),
                wme: nil,
                assignments: %{base_total: 20}
              }
            ]),
            wme: nil,
            assignments: %{discounted_total: 4.6000000000000005}
          },
          %Wongi.Engine.Token{
            ref: #Reference<0.2554059997.3201564677.178619>,
            node_ref: #Reference<0.2554059997.3201564677.178418>,
            parents: MapSet.new([
              %Wongi.Engine.Token{
                ref: #Reference<0.2554059997.3201564677.178615>,
                node_ref: #Reference<0.2554059997.3201564677.178472>,
                parents: MapSet.new([
                  %Wongi.Engine.Token{
                    ref: #Reference<0.2554059997.3201564677.178614>,
                    node_ref: #Reference<0.2554059997.3201564677.178467>,
                    parents: MapSet.new([
                      %Wongi.Engine.Token{
                        ref: #Reference<0.2554059997.3201564677.178599>,
                        node_ref: #Reference<0.2554059997.3201564677.178458>,
                        parents: MapSet.new([
                          %Wongi.Engine.Token{
                            ref: #Reference<0.2554059997.3201564677.178598>,
                            node_ref: #Reference<0.2554059997.3201564677.178457>,
                            parents: MapSet.new([
                              %Wongi.Engine.Token{
                                ref: #Reference<0.2554059997.3201564677.178448>,
                                node_ref: #Reference<0.2554059997.3201564677.178435>,
                                parents: MapSet.new([]),
                                wme: nil,
                                assignments: %{}
                              }
                            ]),
                            wme: WME.new(:item, :price, 10),
                            assignments: %{item: :item, price: 10}
                          }
                        ]),
                        wme: WME.new(:item, :quantity, 2),
                        assignments: %{quantity: 2}
                      }
                    ]),
                    wme: WME.new(:item, :discount, 0.23),
                    assignments: %{discount: 0.23}
                  }
                ]),
                wme: nil,
                assignments: %{base_total: 20}
              }
            ]),
            wme: nil,
            assignments: %{discounted_total: 4.6000000000000005}
          }
        ]),
        WME.new(:item, :discounted_total, 4.6000000000000005) => MapSet.new([
          %Wongi.Engine.Token{
            ref: #Reference<0.2554059997.3201564677.178616>,
            node_ref: #Reference<0.2554059997.3201564676.176675>,
            parents: MapSet.new([
              %Wongi.Engine.Token{
                ref: #Reference<0.2554059997.3201564677.178615>,
                node_ref: #Reference<0.2554059997.3201564677.178472>,
                parents: MapSet.new([
                  %Wongi.Engine.Token{
                    ref: #Reference<0.2554059997.3201564677.178614>,
                    node_ref: #Reference<0.2554059997.3201564677.178467>,
                    parents: MapSet.new([
                      %Wongi.Engine.Token{
                        ref: #Reference<0.2554059997.3201564677.178599>,
                        node_ref: #Reference<0.2554059997.3201564677.178458>,
                        parents: MapSet.new([
                          %Wongi.Engine.Token{
                            ref: #Reference<0.2554059997.3201564677.178598>,
                            node_ref: #Reference<0.2554059997.3201564677.178457>,
                            parents: MapSet.new([
                              %Wongi.Engine.Token{
                                ref: #Reference<0.2554059997.3201564677.178448>,
                                node_ref: #Reference<0.2554059997.3201564677.178435>,
                                parents: MapSet.new([]),
                                wme: nil,
                                assignments: %{}
                              }
                            ]),
                            wme: WME.new(:item, :price, 10),
                            assignments: %{item: :item, price: 10}
                          }
                        ]),
                        wme: WME.new(:item, :quantity, 2),
                        assignments: %{quantity: 2}
                      }
                    ]),
                    wme: WME.new(:item, :discount, 0.23),
                    assignments: %{discount: 0.23}
                  }
                ]),
                wme: nil,
                assignments: %{base_total: 20}
              }
            ]),
            wme: nil,
            assignments: %{discounted_total: 4.6000000000000005}
          },
          %Wongi.Engine.Token{
            ref: #Reference<0.2554059997.3201564677.178617>,
            node_ref: #Reference<0.2554059997.3201564677.178566>,
            parents: MapSet.new([
              %Wongi.Engine.Token{
                ref: #Reference<0.2554059997.3201564677.178615>,
                node_ref: #Reference<0.2554059997.3201564677.178472>,
                parents: MapSet.new([
                  %Wongi.Engine.Token{
                    ref: #Reference<0.2554059997.3201564677.178614>,
                    node_ref: #Reference<0.2554059997.3201564677.178467>,
                    parents: MapSet.new([
                      %Wongi.Engine.Token{
                        ref: #Reference<0.2554059997.3201564677.178599>,
                        node_ref: #Reference<0.2554059997.3201564677.178458>,
                        parents: MapSet.new([
                          %Wongi.Engine.Token{
                            ref: #Reference<0.2554059997.3201564677.178598>,
                            node_ref: #Reference<0.2554059997.3201564677.178457>,
                            parents: MapSet.new([
                              %Wongi.Engine.Token{
                                ref: #Reference<0.2554059997.3201564677.178448>,
                                node_ref: #Reference<0.2554059997.3201564677.178435>,
                                parents: MapSet.new([]),
                                wme: nil,
                                assignments: %{}
                              }
                            ]),
                            wme: WME.new(:item, :price, 10),
                            assignments: %{item: :item, price: 10}
                          }
                        ]),
                        wme: WME.new(:item, :quantity, 2),
                        assignments: %{quantity: 2}
                      }
                    ]),
                    wme: WME.new(:item, :discount, 0.23),
                    assignments: %{discount: 0.23}
                  }
                ]),
                wme: nil,
                assignments: %{base_total: 20}
              }
            ]),
            wme: nil,
            assignments: %{discounted_total: 4.6000000000000005}
          },
          %Wongi.Engine.Token{
            ref: #Reference<0.2554059997.3201564677.178618>,
            node_ref: #Reference<0.2554059997.3201564677.178521>,
            parents: MapSet.new([
              %Wongi.Engine.Token{
                ref: #Reference<0.2554059997.3201564677.178615>,
                node_ref: #Reference<0.2554059997.3201564677.178472>,
                parents: MapSet.new([
                  %Wongi.Engine.Token{
                    ref: #Reference<0.2554059997.3201564677.178614>,
                    node_ref: #Reference<0.2554059997.3201564677.178467>,
                    parents: MapSet.new([
                      %Wongi.Engine.Token{
                        ref: #Reference<0.2554059997.3201564677.178599>,
                        node_ref: #Reference<0.2554059997.3201564677.178458>,
                        parents: MapSet.new([
                          %Wongi.Engine.Token{
                            ref: #Reference<0.2554059997.3201564677.178598>,
                            node_ref: #Reference<0.2554059997.3201564677.178457>,
                            parents: MapSet.new([
                              %Wongi.Engine.Token{
                                ref: #Reference<0.2554059997.3201564677.178448>,
                                node_ref: #Reference<0.2554059997.3201564677.178435>,
                                parents: MapSet.new([]),
                                wme: nil,
                                assignments: %{}
                              }
                            ]),
                            wme: WME.new(:item, :price, 10),
                            assignments: %{item: :item, price: 10}
                          }
                        ]),
                        wme: WME.new(:item, :quantity, 2),
                        assignments: %{quantity: 2}
                      }
                    ]),
                    wme: WME.new(:item, :discount, 0.23),
                    assignments: %{discount: 0.23}
                  }
                ]),
                wme: nil,
                assignments: %{base_total: 20}
              }
            ]),
            wme: nil,
            assignments: %{discounted_total: 4.6000000000000005}
          },
          %Wongi.Engine.Token{
            ref: #Reference<0.2554059997.3201564677.178619>,
            node_ref: #Reference<0.2554059997.3201564677.178418>,
            parents: MapSet.new([
              %Wongi.Engine.Token{
                ref: #Reference<0.2554059997.3201564677.178615>,
                node_ref: #Reference<0.2554059997.3201564677.178472>,
                parents: MapSet.new([
                  %Wongi.Engine.Token{
                    ref: #Reference<0.2554059997.3201564677.178614>,
                    node_ref: #Reference<0.2554059997.3201564677.178467>,
                    parents: MapSet.new([
                      %Wongi.Engine.Token{
                        ref: #Reference<0.2554059997.3201564677.178599>,
                        node_ref: #Reference<0.2554059997.3201564677.178458>,
                        parents: MapSet.new([
                          %Wongi.Engine.Token{
                            ref: #Reference<0.2554059997.3201564677.178598>,
                            node_ref: #Reference<0.2554059997.3201564677.178457>,
                            parents: MapSet.new([
                              %Wongi.Engine.Token{
                                ref: #Reference<0.2554059997.3201564677.178448>,
                                node_ref: #Reference<0.2554059997.3201564677.178435>,
                                parents: MapSet.new([]),
                                wme: nil,
                                assignments: %{}
                              }
                            ]),
                            wme: WME.new(:item, :price, 10),
                            assignments: %{item: :item, price: 10}
                          }
                        ]),
                        wme: WME.new(:item, :quantity, 2),
                        assignments: %{quantity: 2}
                      }
                    ]),
                    wme: WME.new(:item, :discount, 0.23),
                    assignments: %{discount: 0.23}
                  }
                ]),
                wme: nil,
                assignments: %{base_total: 20}
              }
            ]),
            wme: nil,
            assignments: %{discounted_total: 4.6000000000000005}
          }
        ]),
        WME.new(:item, :discounted_total, 10.0) => MapSet.new([
          %Wongi.Engine.Token{
            ref: #Reference<0.2554059997.3201564677.178602>,
            node_ref: #Reference<0.2554059997.3201564676.176675>,
            parents: MapSet.new([
              %Wongi.Engine.Token{
                ref: #Reference<0.2554059997.3201564677.178601>,
                node_ref: #Reference<0.2554059997.3201564677.178472>,
                parents: MapSet.new([
                  %Wongi.Engine.Token{
                    ref: #Reference<0.2554059997.3201564677.178600>,
                    node_ref: #Reference<0.2554059997.3201564677.178467>,
                    parents: MapSet.new([
                      %Wongi.Engine.Token{
                        ref: #Reference<0.2554059997.3201564677.178599>,
                        node_ref: #Reference<0.2554059997.3201564677.178458>,
                        parents: MapSet.new([
                          %Wongi.Engine.Token{
                            ref: #Reference<0.2554059997.3201564677.178598>,
                            node_ref: #Reference<0.2554059997.3201564677.178457>,
                            parents: MapSet.new([
                              %Wongi.Engine.Token{
                                ref: #Reference<0.2554059997.3201564677.178448>,
                                node_ref: #Reference<0.2554059997.3201564677.178435>,
                                parents: MapSet.new([]),
                                wme: nil,
                                assignments: %{}
                              }
                            ]),
                            wme: WME.new(:item, :price, 10),
                            assignments: %{item: :item, price: 10}
                          }
                        ]),
                        wme: WME.new(:item, :quantity, 2),
                        assignments: %{quantity: 2}
                      }
                    ]),
                    wme: WME.new(:item, :discount, 0.5),
                    assignments: %{discount: 0.5}
                  }
                ]),
                wme: nil,
                assignments: %{base_total: 20}
              }
            ]),
            wme: nil,
            assignments: %{discounted_total: 10.0}
          },
          %Wongi.Engine.Token{
            ref: #Reference<0.2554059997.3201564677.178611>,
            node_ref: #Reference<0.2554059997.3201564677.178566>,
            parents: MapSet.new([
              %Wongi.Engine.Token{
                ref: #Reference<0.2554059997.3201564677.178601>,
                node_ref: #Reference<0.2554059997.3201564677.178472>,
                parents: MapSet.new([
                  %Wongi.Engine.Token{
                    ref: #Reference<0.2554059997.3201564677.178600>,
                    node_ref: #Reference<0.2554059997.3201564677.178467>,
                    parents: MapSet.new([
                      %Wongi.Engine.Token{
                        ref: #Reference<0.2554059997.3201564677.178599>,
                        node_ref: #Reference<0.2554059997.3201564677.178458>,
                        parents: MapSet.new([
                          %Wongi.Engine.Token{
                            ref: #Reference<0.2554059997.3201564677.178598>,
                            node_ref: #Reference<0.2554059997.3201564677.178457>,
                            parents: MapSet.new([
                              %Wongi.Engine.Token{
                                ref: #Reference<0.2554059997.3201564677.178448>,
                                node_ref: #Reference<0.2554059997.3201564677.178435>,
                                parents: MapSet.new([]),
                                wme: nil,
                                assignments: %{}
                              }
                            ]),
                            wme: WME.new(:item, :price, 10),
                            assignments: %{item: :item, price: 10}
                          }
                        ]),
                        wme: WME.new(:item, :quantity, 2),
                        assignments: %{quantity: 2}
                      }
                    ]),
                    wme: WME.new(:item, :discount, 0.5),
                    assignments: %{discount: 0.5}
                  }
                ]),
                wme: nil,
                assignments: %{base_total: 20}
              }
            ]),
            wme: nil,
            assignments: %{discounted_total: 10.0}
          },
          %Wongi.Engine.Token{
            ref: #Reference<0.2554059997.3201564677.178612>,
            node_ref: #Reference<0.2554059997.3201564677.178521>,
            parents: MapSet.new([
              %Wongi.Engine.Token{
                ref: #Reference<0.2554059997.3201564677.178601>,
                node_ref: #Reference<0.2554059997.3201564677.178472>,
                parents: MapSet.new([
                  %Wongi.Engine.Token{
                    ref: #Reference<0.2554059997.3201564677.178600>,
                    node_ref: #Reference<0.2554059997.3201564677.178467>,
                    parents: MapSet.new([
                      %Wongi.Engine.Token{
                        ref: #Reference<0.2554059997.3201564677.178599>,
                        node_ref: #Reference<0.2554059997.3201564677.178458>,
                        parents: MapSet.new([
                          %Wongi.Engine.Token{
                            ref: #Reference<0.2554059997.3201564677.178598>,
                            node_ref: #Reference<0.2554059997.3201564677.178457>,
                            parents: MapSet.new([
                              %Wongi.Engine.Token{
                                ref: #Reference<0.2554059997.3201564677.178448>,
                                node_ref: #Reference<0.2554059997.3201564677.178435>,
                                parents: MapSet.new([]),
                                wme: nil,
                                assignments: %{}
                              }
                            ]),
                            wme: WME.new(:item, :price, 10),
                            assignments: %{item: :item, price: 10}
                          }
                        ]),
                        wme: WME.new(:item, :quantity, 2),
                        assignments: %{quantity: 2}
                      }
                    ]),
                    wme: WME.new(:item, :discount, 0.5),
                    assignments: %{discount: 0.5}
                  }
                ]),
                wme: nil,
                assignments: %{base_total: 20}
              }
            ]),
            wme: nil,
            assignments: %{discounted_total: 10.0}
          },
          %Wongi.Engine.Token{
            ref: #Reference<0.2554059997.3201564677.178613>,
            node_ref: #Reference<0.2554059997.3201564677.178418>,
            parents: MapSet.new([
              %Wongi.Engine.Token{
                ref: #Reference<0.2554059997.3201564677.178601>,
                node_ref: #Reference<0.2554059997.3201564677.178472>,
                parents: MapSet.new([
                  %Wongi.Engine.Token{
                    ref: #Reference<0.2554059997.3201564677.178600>,
                    node_ref: #Reference<0.2554059997.3201564677.178467>,
                    parents: MapSet.new([
                      %Wongi.Engine.Token{
                        ref: #Reference<0.2554059997.3201564677.178599>,
                        node_ref: #Reference<0.2554059997.3201564677.178458>,
                        parents: MapSet.new([
                          %Wongi.Engine.Token{
                            ref: #Reference<0.2554059997.3201564677.178598>,
                            node_ref: #Reference<0.2554059997.3201564677.178457>,
                            parents: MapSet.new([
                              %Wongi.Engine.Token{
                                ref: #Reference<0.2554059997.3201564677.178448>,
                                node_ref: #Reference<0.2554059997.3201564677.178435>,
                                parents: MapSet.new([]),
                                wme: nil,
                                assignments: %{}
                              }
                            ]),
                            wme: WME.new(:item, :price, 10),
                            assignments: %{item: :item, price: 10}
                          }
                        ]),
                        wme: WME.new(:item, :quantity, 2),
                        assignments: %{quantity: 2}
                      }
                    ]),
                    wme: WME.new(:item, :discount, 0.5),
                    assignments: %{discount: 0.5}
                  }
                ]),
                wme: nil,
                assignments: %{base_total: 20}
              }
            ]),
            wme: nil,
            assignments: %{discounted_total: 10.0}
          }
        ])
      },
      by_token: %{
        %Wongi.Engine.Token{
          ref: #Reference<0.2554059997.3201564677.178602>,
          node_ref: #Reference<0.2554059997.3201564676.176675>,
          parents: MapSet.new([
            %Wongi.Engine.Token{
              ref: #Reference<0.2554059997.3201564677.178601>,
              node_ref: #Reference<0.2554059997.3201564677.178472>,
              parents: MapSet.new([
                %Wongi.Engine.Token{
                  ref: #Reference<0.2554059997.3201564677.178600>,
                  node_ref: #Reference<0.2554059997.3201564677.178467>,
                  parents: MapSet.new([
                    %Wongi.Engine.Token{
                      ref: #Reference<0.2554059997.3201564677.178599>,
                      node_ref: #Reference<0.2554059997.3201564677.178458>,
                      parents: MapSet.new([
                        %Wongi.Engine.Token{
                          ref: #Reference<0.2554059997.3201564677.178598>,
                          node_ref: #Reference<0.2554059997.3201564677.178457>,
                          parents: MapSet.new([
                            %Wongi.Engine.Token{
                              ref: #Reference<0.2554059997.3201564677.178448>,
                              node_ref: #Reference<0.2554059997.3201564677.178435>,
                              parents: MapSet.new([]),
                              wme: nil,
                              assignments: %{}
                            }
                          ]),
                          wme: WME.new(:item, :price, 10),
                          assignments: %{item: :item, price: 10}
                        }
                      ]),
                      wme: WME.new(:item, :quantity, 2),
                      assignments: %{quantity: 2}
                    }
                  ]),
                  wme: WME.new(:item, :discount, 0.5),
                  assignments: %{discount: 0.5}
                }
              ]),
              wme: nil,
              assignments: %{base_total: 20}
            }
          ]),
          wme: nil,
          assignments: %{discounted_total: 10.0}
        } => MapSet.new([WME.new(:item, :base_total, 20),
         WME.new(:item, :discounted_total, 10.0)]),
        %Wongi.Engine.Token{
          ref: #Reference<0.2554059997.3201564677.178611>,
          node_ref: #Reference<0.2554059997.3201564677.178566>,
          parents: MapSet.new([
            %Wongi.Engine.Token{
              ref: #Reference<0.2554059997.3201564677.178601>,
              node_ref: #Reference<0.2554059997.3201564677.178472>,
              parents: MapSet.new([
                %Wongi.Engine.Token{
                  ref: #Reference<0.2554059997.3201564677.178600>,
                  node_ref: #Reference<0.2554059997.3201564677.178467>,
                  parents: MapSet.new([
                    %Wongi.Engine.Token{
                      ref: #Reference<0.2554059997.3201564677.178599>,
                      node_ref: #Reference<0.2554059997.3201564677.178458>,
                      parents: MapSet.new([
                        %Wongi.Engine.Token{
                          ref: #Reference<0.2554059997.3201564677.178598>,
                          node_ref: #Reference<0.2554059997.3201564677.178457>,
                          parents: MapSet.new([
                            %Wongi.Engine.Token{
                              ref: #Reference<0.2554059997.3201564677.178448>,
                              node_ref: #Reference<0.2554059997.3201564677.178435>,
                              parents: MapSet.new([]),
                              wme: nil,
                              assignments: %{}
                            }
                          ]),
                          wme: WME.new(:item, :price, 10),
                          assignments: %{item: :item, price: 10}
                        }
                      ]),
                      wme: WME.new(:item, :quantity, 2),
                      assignments: %{quantity: 2}
                    }
                  ]),
                  wme: WME.new(:item, :discount, 0.5),
                  assignments: %{discount: 0.5}
                }
              ]),
              wme: nil,
              assignments: %{base_total: 20}
            }
          ]),
          wme: nil,
          assignments: %{discounted_total: 10.0}
        } => MapSet.new([WME.new(:item, :base_total, 20),
         WME.new(:item, :discounted_total, 10.0)]),
        %Wongi.Engine.Token{
          ref: #Reference<0.2554059997.3201564677.178612>,
          node_ref: #Reference<0.2554059997.3201564677.178521>,
          parents: MapSet.new([
            %Wongi.Engine.Token{
              ref: #Reference<0.2554059997.3201564677.178601>,
              node_ref: #Reference<0.2554059997.3201564677.178472>,
              parents: MapSet.new([
                %Wongi.Engine.Token{
                  ref: #Reference<0.2554059997.3201564677.178600>,
                  node_ref: #Reference<0.2554059997.3201564677.178467>,
                  parents: MapSet.new([
                    %Wongi.Engine.Token{
                      ref: #Reference<0.2554059997.3201564677.178599>,
                      node_ref: #Reference<0.2554059997.3201564677.178458>,
                      parents: MapSet.new([
                        %Wongi.Engine.Token{
                          ref: #Reference<0.2554059997.3201564677.178598>,
                          node_ref: #Reference<0.2554059997.3201564677.178457>,
                          parents: MapSet.new([
                            %Wongi.Engine.Token{
                              ref: #Reference<0.2554059997.3201564677.178448>,
                              node_ref: #Reference<0.2554059997.3201564677.178435>,
                              parents: MapSet.new([]),
                              wme: nil,
                              assignments: %{}
                            }
                          ]),
                          wme: WME.new(:item, :price, 10),
                          assignments: %{item: :item, price: 10}
                        }
                      ]),
                      wme: WME.new(:item, :quantity, 2),
                      assignments: %{quantity: 2}
                    }
                  ]),
                  wme: WME.new(:item, :discount, 0.5),
                  assignments: %{discount: 0.5}
                }
              ]),
              wme: nil,
              assignments: %{base_total: 20}
            }
          ]),
          wme: nil,
          assignments: %{discounted_total: 10.0}
        } => MapSet.new([WME.new(:item, :base_total, 20),
         WME.new(:item, :discounted_total, 10.0)]),
        %Wongi.Engine.Token{
          ref: #Reference<0.2554059997.3201564677.178613>,
          node_ref: #Reference<0.2554059997.3201564677.178418>,
          parents: MapSet.new([
            %Wongi.Engine.Token{
              ref: #Reference<0.2554059997.3201564677.178601>,
              node_ref: #Reference<0.2554059997.3201564677.178472>,
              parents: MapSet.new([
                %Wongi.Engine.Token{
                  ref: #Reference<0.2554059997.3201564677.178600>,
                  node_ref: #Reference<0.2554059997.3201564677.178467>,
                  parents: MapSet.new([
                    %Wongi.Engine.Token{
                      ref: #Reference<0.2554059997.3201564677.178599>,
                      node_ref: #Reference<0.2554059997.3201564677.178458>,
                      parents: MapSet.new([
                        %Wongi.Engine.Token{
                          ref: #Reference<0.2554059997.3201564677.178598>,
                          node_ref: #Reference<0.2554059997.3201564677.178457>,
                          parents: MapSet.new([
                            %Wongi.Engine.Token{
                              ref: #Reference<0.2554059997.3201564677.178448>,
                              node_ref: #Reference<0.2554059997.3201564677.178435>,
                              parents: MapSet.new([]),
                              wme: nil,
                              assignments: %{}
                            }
                          ]),
                          wme: WME.new(:item, :price, 10),
                          assignments: %{item: :item, price: 10}
                        }
                      ]),
                      wme: WME.new(:item, :quantity, 2),
                      assignments: %{quantity: 2}
                    }
                  ]),
                  wme: WME.new(:item, :discount, 0.5),
                  assignments: %{discount: 0.5}
                }
              ]),
              wme: nil,
              assignments: %{base_total: 20}
            }
          ]),
          wme: nil,
          assignments: %{discounted_total: 10.0}
        } => MapSet.new([WME.new(:item, :base_total, 20),
         WME.new(:item, :discounted_total, 10.0)]),
        %Wongi.Engine.Token{
          ref: #Reference<0.2554059997.3201564677.178616>,
          node_ref: #Reference<0.2554059997.3201564676.176675>,
          parents: MapSet.new([
            %Wongi.Engine.Token{
              ref: #Reference<0.2554059997.3201564677.178615>,
              node_ref: #Reference<0.2554059997.3201564677.178472>,
              parents: MapSet.new([
                %Wongi.Engine.Token{
                  ref: #Reference<0.2554059997.3201564677.178614>,
                  node_ref: #Reference<0.2554059997.3201564677.178467>,
                  parents: MapSet.new([
                    %Wongi.Engine.Token{
                      ref: #Reference<0.2554059997.3201564677.178599>,
                      node_ref: #Reference<0.2554059997.3201564677.178458>,
                      parents: MapSet.new([
                        %Wongi.Engine.Token{
                          ref: #Reference<0.2554059997.3201564677.178598>,
                          node_ref: #Reference<0.2554059997.3201564677.178457>,
                          parents: MapSet.new([
                            %Wongi.Engine.Token{
                              ref: #Reference<0.2554059997.3201564677.178448>,
                              node_ref: #Reference<0.2554059997.3201564677.178435>,
                              parents: MapSet.new([]),
                              wme: nil,
                              assignments: %{}
                            }
                          ]),
                          wme: WME.new(:item, :price, 10),
                          assignments: %{item: :item, price: 10}
                        }
                      ]),
                      wme: WME.new(:item, :quantity, 2),
                      assignments: %{quantity: 2}
                    }
                  ]),
                  wme: WME.new(:item, :discount, 0.23),
                  assignments: %{discount: 0.23}
                }
              ]),
              wme: nil,
              assignments: %{base_total: 20}
            }
          ]),
          wme: nil,
          assignments: %{discounted_total: 4.6000000000000005}
        } => MapSet.new([WME.new(:item, :base_total, 20),
         WME.new(:item, :discounted_total, 4.6000000000000005)]),
        %Wongi.Engine.Token{
          ref: #Reference<0.2554059997.3201564677.178617>,
          node_ref: #Reference<0.2554059997.3201564677.178566>,
          parents: MapSet.new([
            %Wongi.Engine.Token{
              ref: #Reference<0.2554059997.3201564677.178615>,
              node_ref: #Reference<0.2554059997.3201564677.178472>,
              parents: MapSet.new([
                %Wongi.Engine.Token{
                  ref: #Reference<0.2554059997.3201564677.178614>,
                  node_ref: #Reference<0.2554059997.3201564677.178467>,
                  parents: MapSet.new([
                    %Wongi.Engine.Token{
                      ref: #Reference<0.2554059997.3201564677.178599>,
                      node_ref: #Reference<0.2554059997.3201564677.178458>,
                      parents: MapSet.new([
                        %Wongi.Engine.Token{
                          ref: #Reference<0.2554059997.3201564677.178598>,
                          node_ref: #Reference<0.2554059997.3201564677.178457>,
                          parents: MapSet.new([
                            %Wongi.Engine.Token{
                              ref: #Reference<0.2554059997.3201564677.178448>,
                              node_ref: #Reference<0.2554059997.3201564677.178435>,
                              parents: MapSet.new([]),
                              wme: nil,
                              assignments: %{}
                            }
                          ]),
                          wme: WME.new(:item, :price, 10),
                          assignments: %{item: :item, price: 10}
                        }
                      ]),
                      wme: WME.new(:item, :quantity, 2),
                      assignments: %{quantity: 2}
                    }
                  ]),
                  wme: WME.new(:item, :discount, 0.23),
                  assignments: %{discount: 0.23}
                }
              ]),
              wme: nil,
              assignments: %{base_total: 20}
            }
          ]),
          wme: nil,
          assignments: %{discounted_total: 4.6000000000000005}
        } => MapSet.new([WME.new(:item, :base_total, 20),
         WME.new(:item, :discounted_total, 4.6000000000000005)]),
        %Wongi.Engine.Token{
          ref: #Reference<0.2554059997.3201564677.178618>,
          node_ref: #Reference<0.2554059997.3201564677.178521>,
          parents: MapSet.new([
            %Wongi.Engine.Token{
              ref: #Reference<0.2554059997.3201564677.178615>,
              node_ref: #Reference<0.2554059997.3201564677.178472>,
              parents: MapSet.new([
                %Wongi.Engine.Token{
                  ref: #Reference<0.2554059997.3201564677.178614>,
                  node_ref: #Reference<0.2554059997.3201564677.178467>,
                  parents: MapSet.new([
                    %Wongi.Engine.Token{
                      ref: #Reference<0.2554059997.3201564677.178599>,
                      node_ref: #Reference<0.2554059997.3201564677.178458>,
                      parents: MapSet.new([
                        %Wongi.Engine.Token{
                          ref: #Reference<0.2554059997.3201564677.178598>,
                          node_ref: #Reference<0.2554059997.3201564677.178457>,
                          parents: MapSet.new([
                            %Wongi.Engine.Token{
                              ref: #Reference<0.2554059997.3201564677.178448>,
                              node_ref: #Reference<0.2554059997.3201564677.178435>,
                              parents: MapSet.new([]),
                              wme: nil,
                              assignments: %{}
                            }
                          ]),
                          wme: WME.new(:item, :price, 10),
                          assignments: %{item: :item, price: 10}
                        }
                      ]),
                      wme: WME.new(:item, :quantity, 2),
                      assignments: %{quantity: 2}
                    }
                  ]),
                  wme: WME.new(:item, :discount, 0.23),
                  assignments: %{discount: 0.23}
                }
              ]),
              wme: nil,
              assignments: %{base_total: 20}
            }
          ]),
          wme: nil,
          assignments: %{discounted_total: 4.6000000000000005}
        } => MapSet.new([WME.new(:item, :base_total, 20),
         WME.new(:item, :discounted_total, 4.6000000000000005)]),
        %Wongi.Engine.Token{
          ref: #Reference<0.2554059997.3201564677.178619>,
          node_ref: #Reference<0.2554059997.3201564677.178418>,
          parents: MapSet.new([
            %Wongi.Engine.Token{
              ref: #Reference<0.2554059997.3201564677.178615>,
              node_ref: #Reference<0.2554059997.3201564677.178472>,
              parents: MapSet.new([
                %Wongi.Engine.Token{
                  ref: #Reference<0.2554059997.3201564677.178614>,
                  node_ref: #Reference<0.2554059997.3201564677.178467>,
                  parents: MapSet.new([
                    %Wongi.Engine.Token{
                      ref: #Reference<0.2554059997.3201564677.178599>,
                      node_ref: #Reference<0.2554059997.3201564677.178458>,
                      parents: MapSet.new([
                        %Wongi.Engine.Token{
                          ref: #Reference<0.2554059997.3201564677.178598>,
                          node_ref: #Reference<0.2554059997.3201564677.178457>,
                          parents: MapSet.new([
                            %Wongi.Engine.Token{
                              ref: #Reference<0.2554059997.3201564677.178448>,
                              node_ref: #Reference<0.2554059997.3201564677.178435>,
                              parents: MapSet.new([]),
                              wme: nil,
                              assignments: %{}
                            }
                          ]),
                          wme: WME.new(:item, :price, 10),
                          assignments: %{item: :item, price: 10}
                        }
                      ]),
                      wme: WME.new(:item, :quantity, 2),
                      assignments: %{quantity: 2}
                    }
                  ]),
                  wme: WME.new(:item, :discount, 0.23),
                  assignments: %{discount: 0.23}
                }
              ]),
              wme: nil,
              assignments: %{base_total: 20}
            }
          ]),
          wme: nil,
          assignments: %{discounted_total: 4.6000000000000005}
        } => MapSet.new([WME.new(:item, :base_total, 20),
         WME.new(:item, :discounted_total, 4.6000000000000005)])
      }
    },
    ncc_tokens: %{},
    ncc_owners: %{}
  },
  alpha_subscriptions: %{
    [:_, :discount, :_] => [#Reference<0.2554059997.3201564677.178458>],
    [:_, :price, :_] => [#Reference<0.2554059997.3201564677.178435>],
    [:_, :quantity, :_] => [#Reference<0.2554059997.3201564677.178457>]
  },
  beta_root: %Wongi.Engine.Beta.Root{
    ref: #Reference<0.2554059997.3201564679.177147>
  },
  beta_table: %{
    #Reference<0.2554059997.3201564676.176675> => %Wongi.Engine.Beta.Production{
      ref: #Reference<0.2554059997.3201564676.176675>,
      parent_ref: #Reference<0.2554059997.3201564677.178472>,
      actions: [
        %Wongi.Engine.Action.Generator{
          template: WME.new(%Wongi.Engine.DSL.Var{name: :item}, :base_total, %Wongi.Engine.DSL.Var{
            name: :base_total
          })
        },
        %Wongi.Engine.Action.Generator{
          template: WME.new(%Wongi.Engine.DSL.Var{name: :item}, :discounted_total, %Wongi.Engine.DSL.Var{
            name: :discounted_total
          })
        }
      ]
    },
    #Reference<0.2554059997.3201564677.178418> => %Wongi.Engine.Beta.Production{
      ref: #Reference<0.2554059997.3201564677.178418>,
      parent_ref: #Reference<0.2554059997.3201564677.178472>,
      actions: [
        %Wongi.Engine.Action.Generator{
          template: WME.new(%Wongi.Engine.DSL.Var{name: :item}, :base_total, %Wongi.Engine.DSL.Var{
            name: :base_total
          })
        },
        %Wongi.Engine.Action.Generator{
          template: WME.new(%Wongi.Engine.DSL.Var{name: :item}, :discounted_total, %Wongi.Engine.DSL.Var{
            name: :discounted_total
          })
        }
      ]
    },
    #Reference<0.2554059997.3201564677.178435> => %Wongi.Engine.Beta.Join{
      ref: #Reference<0.2554059997.3201564677.178435>,
      parent_ref: #Reference<0.2554059997.3201564679.177147>,
      template: WME.new(:_, :price, :_),
      tests: %{},
      assignments: %{object: :price, subject: :item},
      filters: nil
    },
    #Reference<0.2554059997.3201564677.178457> => %Wongi.Engine.Beta.Join{
      ref: #Reference<0.2554059997.3201564677.178457>,
      parent_ref: #Reference<0.2554059997.3201564677.178435>,
      template: WME.new(:_, :quantity, :_),
      tests: %{subject: :item},
      assignments: %{object: :quantity},
      filters: nil
    },
    #Reference<0.2554059997.3201564677.178458> => %Wongi.Engine.Beta.Join{
      ref: #Reference<0.2554059997.3201564677.178458>,
      parent_ref: #Reference<0.2554059997.3201564677.178457>,
      template: WME.new(:_, :discount, :_),
      tests: %{subject: :item},
      assignments: %{object: :discount},
      filters: nil
    },
    #Reference<0.2554059997.3201564677.178467> => %Wongi.Engine.Beta.Assign{
      ref: #Reference<0.2554059997.3201564677.178467>,
      parent_ref: #Reference<0.2554059997.3201564677.178458>,
      name: :base_total,
      value: #Function<42.105768164/1 in :erl_eval.expr/6>
    },
    #Reference<0.2554059997.3201564677.178472> => %Wongi.Engine.Beta.Assign{
      ref: #Reference<0.2554059997.3201564677.178472>,
      parent_ref: #Reference<0.2554059997.3201564677.178467>,
      name: :discounted_total,
      value: #Function<42.105768164/1 in :erl_eval.expr/6>
    },
    #Reference<0.2554059997.3201564677.178521> => %Wongi.Engine.Beta.Production{
      ref: #Reference<0.2554059997.3201564677.178521>,
      parent_ref: #Reference<0.2554059997.3201564677.178472>,
      actions: [
        %Wongi.Engine.Action.Generator{
          template: WME.new(%Wongi.Engine.DSL.Var{name: :item}, :base_total, %Wongi.Engine.DSL.Var{
            name: :base_total
          })
        },
        %Wongi.Engine.Action.Generator{
          template: WME.new(%Wongi.Engine.DSL.Var{name: :item}, :discounted_total, %Wongi.Engine.DSL.Var{
            name: :discounted_total
          })
        }
      ]
    },
    #Reference<0.2554059997.3201564677.178566> => %Wongi.Engine.Beta.Production{
      ref: #Reference<0.2554059997.3201564677.178566>,
      parent_ref: #Reference<0.2554059997.3201564677.178472>,
      actions: [
        %Wongi.Engine.Action.Generator{
          template: WME.new(%Wongi.Engine.DSL.Var{name: :item}, :base_total, %Wongi.Engine.DSL.Var{
            name: :base_total
          })
        },
        %Wongi.Engine.Action.Generator{
          template: WME.new(%Wongi.Engine.DSL.Var{name: :item}, :discounted_total, %Wongi.Engine.DSL.Var{
            name: :discounted_total
          })
        }
      ]
    },
    #Reference<0.2554059997.3201564679.177147> => %Wongi.Engine.Beta.Root{
      ref: #Reference<0.2554059997.3201564679.177147>
    }
  },
  beta_subscriptions: %{
    #Reference<0.2554059997.3201564677.178435> => [#Reference<0.2554059997.3201564677.178457>],
    #Reference<0.2554059997.3201564677.178457> => [#Reference<0.2554059997.3201564677.178458>],
    #Reference<0.2554059997.3201564677.178458> => [#Reference<0.2554059997.3201564677.178467>],
    #Reference<0.2554059997.3201564677.178467> => [#Reference<0.2554059997.3201564677.178472>],
    #Reference<0.2554059997.3201564677.178472> => [#Reference<0.2554059997.3201564676.176675>,
     #Reference<0.2554059997.3201564677.178566>,
     #Reference<0.2554059997.3201564677.178521>,
     #Reference<0.2554059997.3201564677.178418>],
    #Reference<0.2554059997.3201564679.177147> => [#Reference<0.2554059997.3201564677.178435>]
  },
  productions: MapSet.new([#Reference<0.2554059997.3201564676.176675>,
   #Reference<0.2554059997.3201564677.178418>,
   #Reference<0.2554059997.3201564677.178521>,
   #Reference<0.2554059997.3201564677.178566>]),
  processing: false,
  ...
>
