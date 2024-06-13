Compiling 22 files (.ex)
Generated tpe app
Remember to keep good posture and stay hydrated!

19:15:43.257 [debug] QUERY OK source="rule" db=6.1ms decode=2.5ms queue=15.8ms idle=0.0ms
INSERT INTO "rule" ("active","name","type","description","updated_at") VALUES ($1,$2,$3,$4,$5) RETURNING "id" [true, "promo 1", "basic", "a new promo", ~U[2024-06-13 19:15:43.199837Z]]

19:15:43.394 [debug] QUERY OK source="rule_parts" db=131.6ms queue=0.5ms idle=20.0ms
INSERT INTO "rule_parts" ("block","arguments","updated_at","rule_id","verb") VALUES ($1,$2,$3,$4,$5) RETURNING "id" ["do", %{subject: "var(:item)", predicate: :base_total, object: "var(:base_total)"}, ~U[2024-06-13 19:15:43.259871Z], 702, "generator"]

19:15:43.401 [debug] QUERY OK source="rule_parts" db=6.9ms queue=0.6ms idle=153.9ms
INSERT INTO "rule_parts" ("block","arguments","updated_at","rule_id","verb") VALUES ($1,$2,$3,$4,$5) RETURNING "id" ["do", %{subject: "var(:item)", predicate: :discounted_total, object: "var(:discounted_total)"}, ~U[2024-06-13 19:15:43.394100Z], 702, "generator"]

19:15:43.409 [debug] QUERY OK source="rule_parts" db=7.0ms queue=0.7ms idle=161.7ms
INSERT INTO "rule_parts" ("block","arguments","updated_at","rule_id","verb") VALUES ($1,$2,$3,$4,$5) RETURNING "id" ["forall", %{filter: nil, subject: "var(:item)", predicate: :price, object: "var(:price)"}, ~U[2024-06-13 19:15:43.401902Z], 702, "has"]

19:15:43.418 [debug] QUERY OK source="rule_parts" db=7.1ms queue=0.8ms idle=169.9ms
INSERT INTO "rule_parts" ("block","arguments","updated_at","rule_id","verb") VALUES ($1,$2,$3,$4,$5) RETURNING "id" ["forall", %{filter: "Wongi.Engine.DSL.gte( var(:quantity), 1)", subject: "var(:item)", predicate: :quantity, object: "var(:quantity)"}, ~U[2024-06-13 19:15:43.410112Z], 702, "has"]

19:15:43.426 [debug] QUERY OK source="rule_parts" db=7.0ms queue=0.6ms idle=178.0ms
INSERT INTO "rule_parts" ("block","arguments","updated_at","rule_id","verb") VALUES ($1,$2,$3,$4,$5) RETURNING "id" ["forall", %{filter: nil, subject: "var(:item)", predicate: :discount, object: "var(:discount)"}, ~U[2024-06-13 19:15:43.418294Z], 702, "has"]

19:15:43.431 [debug] QUERY OK source="rule_parts" db=5.1ms queue=0.4ms idle=186.0ms
INSERT INTO "rule_parts" ("block","arguments","updated_at","rule_id","verb","order") VALUES ($1,$2,$3,$4,$5,$6) RETURNING "id" ["forall", %{name: :base_total, value: "&(&1[:price] * &1[:quantity])", eval: "dune"}, ~U[2024-06-13 19:15:43.426226Z], 702, "assign", 0]

19:15:43.442 [debug] QUERY OK source="rule_parts" db=3.8ms queue=1.0ms idle=197.1ms
SELECT r0."id", r0."rule_id", r0."block", r0."verb", r0."arguments", r0."order", r0."inserted_at", r0."updated_at" FROM "rule_parts" AS r0 WHERE ((r0."rule_id" = $1) AND (r0."verb" = $2)) [702, "assign"]

19:15:43.451 [debug] QUERY OK source="rule_parts" db=5.4ms queue=0.8ms idle=204.6ms
INSERT INTO "rule_parts" ("block","arguments","updated_at","rule_id","verb","order") VALUES ($1,$2,$3,$4,$5,$6) RETURNING "id" ["forall", %{name: :discounted_total, value: "&(&1[:base_total]) * &1[:discount]", eval: "dune"}, ~U[2024-06-13 19:15:43.444988Z], 702, "assign", 0]

19:15:43.453 [debug] QUERY OK source="rule_parts" db=1.6ms idle=211.2ms
SELECT r0."id", r0."rule_id", r0."block", r0."verb", r0."arguments", r0."order", r0."inserted_at", r0."updated_at" FROM "rule_parts" AS r0 WHERE ((r0."rule_id" = $1) AND (r0."verb" = $2)) [702, "assign"]

19:15:43.455 [debug] QUERY OK source="rule_parts" db=0.6ms queue=0.3ms idle=207.9ms
SELECT r0."id", r0."rule_id", r0."block", r0."verb", r0."arguments", r0."order", r0."inserted_at", r0."updated_at" FROM "rule_parts" AS r0 WHERE (r0."id" = $1) [2624]

19:15:43.464 [debug] QUERY OK source="rule_parts" db=8.4ms queue=0.2ms idle=63.4ms
UPDATE "rule_parts" SET "updated_at" = $1, "order" = $2 WHERE "id" = $3 [~U[2024-06-13 19:15:43.453453Z], 3, 2624]

19:15:43.465 [debug] QUERY OK source="rule_parts" db=0.6ms idle=63.0ms
SELECT r0."id", r0."rule_id", r0."block", r0."verb", r0."arguments", r0."order", r0."inserted_at", r0."updated_at" FROM "rule_parts" AS r0 WHERE (r0."id" = $1) [2623]

19:15:43.491 [debug] QUERY OK source="rule_parts" db=26.0ms queue=0.2ms idle=55.8ms
UPDATE "rule_parts" SET "updated_at" = $1, "order" = $2 WHERE "id" = $3 [~U[2024-06-13 19:15:43.464736Z], 1, 2623]

19:15:43.506 [debug] QUERY OK source="rule" db=3.5ms queue=0.3ms idle=84.2ms
SELECT r0."id" FROM "rule" AS r0 WHERE (r0."active" = TRUE) AND (r0."valid_from" <= $1) AND ((r0."valid_to" IS NULL) OR (r0."valid_to" >= $2)) [~U[2024-06-13 19:15:43Z], ~U[2024-06-13 19:15:43Z]]

19:15:43.507 [debug] QUERY OK source="rule_parts" db=0.3ms queue=0.2ms idle=80.4ms
SELECT r0."id", r0."rule_id", r0."block", r0."verb", r0."arguments", r0."order", r0."inserted_at", r0."updated_at" FROM "rule_parts" AS r0 WHERE (r0."rule_id" = $1) [391]

19:15:43.572 [debug] QUERY OK source="rule_parts" db=0.7ms idle=139.4ms
SELECT r0."id", r0."rule_id", r0."block", r0."verb", r0."arguments", r0."order", r0."inserted_at", r0."updated_at" FROM "rule_parts" AS r0 WHERE (r0."rule_id" = $1) [392]

19:15:43.575 [debug] QUERY OK source="rule_parts" db=0.7ms idle=132.0ms
SELECT r0."id", r0."rule_id", r0."block", r0."verb", r0."arguments", r0."order", r0."inserted_at", r0."updated_at" FROM "rule_parts" AS r0 WHERE (r0."rule_id" = $1) [393]

19:15:43.578 [debug] QUERY OK source="rule_parts" db=1.0ms idle=125.9ms
SELECT r0."id", r0."rule_id", r0."block", r0."verb", r0."arguments", r0."order", r0."inserted_at", r0."updated_at" FROM "rule_parts" AS r0 WHERE (r0."rule_id" = $1) [394]

19:15:43.581 [debug] QUERY OK source="rule_parts" db=0.3ms idle=127.2ms
SELECT r0."id", r0."rule_id", r0."block", r0."verb", r0."arguments", r0."order", r0."inserted_at", r0."updated_at" FROM "rule_parts" AS r0 WHERE (r0."rule_id" = $1) [395]

19:15:43.583 [debug] QUERY OK source="rule_parts" db=0.5ms idle=127.2ms
SELECT r0."id", r0."rule_id", r0."block", r0."verb", r0."arguments", r0."order", r0."inserted_at", r0."updated_at" FROM "rule_parts" AS r0 WHERE (r0."rule_id" = $1) [396]

19:15:43.586 [debug] QUERY OK source="rule_parts" db=0.5ms idle=121.0ms
SELECT r0."id", r0."rule_id", r0."block", r0."verb", r0."arguments", r0."order", r0."inserted_at", r0."updated_at" FROM "rule_parts" AS r0 WHERE (r0."rule_id" = $1) [397]

19:15:43.589 [debug] QUERY OK source="rule_parts" db=0.8ms idle=123.3ms
SELECT r0."id", r0."rule_id", r0."block", r0."verb", r0."arguments", r0."order", r0."inserted_at", r0."updated_at" FROM "rule_parts" AS r0 WHERE (r0."rule_id" = $1) [398]

19:15:43.593 [debug] QUERY OK source="rule_parts" db=1.1ms idle=100.3ms
SELECT r0."id", r0."rule_id", r0."block", r0."verb", r0."arguments", r0."order", r0."inserted_at", r0."updated_at" FROM "rule_parts" AS r0 WHERE (r0."rule_id" = $1) [399]

19:15:43.596 [debug] QUERY OK source="rule_parts" db=0.5ms idle=89.1ms
SELECT r0."id", r0."rule_id", r0."block", r0."verb", r0."arguments", r0."order", r0."inserted_at", r0."updated_at" FROM "rule_parts" AS r0 WHERE (r0."rule_id" = $1) [400]

19:15:43.598 [debug] QUERY OK source="rule_parts" db=0.3ms idle=91.0ms
SELECT r0."id", r0."rule_id", r0."block", r0."verb", r0."arguments", r0."order", r0."inserted_at", r0."updated_at" FROM "rule_parts" AS r0 WHERE (r0."rule_id" = $1) [401]

19:15:43.601 [debug] QUERY OK source="rule_parts" db=0.4ms idle=28.5ms
SELECT r0."id", r0."rule_id", r0."block", r0."verb", r0."arguments", r0."order", r0."inserted_at", r0."updated_at" FROM "rule_parts" AS r0 WHERE (r0."rule_id" = $1) [402]

19:15:43.603 [debug] QUERY OK source="rule_parts" db=0.4ms idle=28.2ms
SELECT r0."id", r0."rule_id", r0."block", r0."verb", r0."arguments", r0."order", r0."inserted_at", r0."updated_at" FROM "rule_parts" AS r0 WHERE (r0."rule_id" = $1) [702]
[WME.new(:item, :base_total, 20), WME.new(:item, :discount, 0.23),
 WME.new(:item, :discount, 0.5),
 WME.new(:item, :discounted_total, 4.6000000000000005),
 WME.new(:item, :discounted_total, 10.0), WME.new(:item, :price, 10),
 WME.new(:item, :quantity, 2)]
