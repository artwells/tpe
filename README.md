# Tpe

**WORK IN PROGRESS: Tempt Promotion Engine**
**A discount and coupon management engine built with Elixir**

## Prerequisites

- Elixir 1.14+
- PostgreSQL 14+
- Docker (optional)

## Setup

```bash
# Clone the repository
git clone git@github.com:artwells/tpe.git

# Install dependencies
mix deps.get

# Create and migrate database
mix ecto.create
mix ecto.migrate

## Development 
# Start the application
iex -S mix

# Run tests
mix test

```
## Architecture

- Rule engine using Wongi
-- Dune to sanitize stored rules
- PostgreSQL for persistence
- Ecto for database interactions


## Project Structure

```
lib/
    tpe/
        coupon/     # Coupon management
        engine/     # Rule engine
```

## Coupon Management

The `Tpe.Coupon` namespace provides comprehensive coupon management through several modules:

### Create (`Tpe.Coupon.Create`)
- Single coupon creation
- Bulk creation with randomized codes
- CSV import support
- Configurable code generation (prefix, suffix, length)

```elixir
# Create a single coupon
{:ok, coupon} = Tpe.Coupon.Create.create_coupon(%{
  code: "ABC123",
  active: true,
  count: 5,
  max_use: 6,
  promo_id: 1
})

# Bulk create coupons
{:ok, count} = Tpe.Coupon.Create.mass_create(100, promo_id, chunk_size, max_use)

# Import from CSV
{:ok, count} = Tpe.Coupon.Create.insert_coupons_from_csv("path/to/coupons.csv")
```

### Read (`Tpe.Coupon.Read`)
- Lookup by ID or code
- Validation of coupon status
- Bulk retrieval by promotion
- Optional code formatting (with dashes)

```elixir
# Get coupon by code
{:ok, coupon} = Tpe.Coupon.Read.get_coupon_by_code("ABC123")

# Get all coupons for a promotion
coupons = Tpe.Coupon.Read.dump_coupons_by_promo_id(promo_id)
```

### Update (`Tpe.Coupon.Update`)
- Modify coupon attributes
- Update usage counts
- Toggle activation status


```elixir
# Update coupon attributes
{:ok, updated_coupon} = Tpe.Coupon.Update.update_coupon(coupon, %{
  active: false,
  count: 0
})

# Decrement usage count
{:ok, updated_coupon} = Tpe.Coupon.Update.decrement_count(coupon)

# Deactivate coupon
{:ok, updated_coupon} = Tpe.Coupon.Update.deactivate(coupon)

# Update multiple coupons for a promotion
{:ok, count} = Tpe.Coupon.Update.bulk_update_by_promo_id(promo_id, %{
  active: false
})
```

### Delete (`Tpe.Coupon.Delete`)
- Remove individual coupons
- Bulk deletion options
```elixir
# Delete a single coupon
{:ok, deleted_coupon} = Tpe.Coupon.Delete.delete_coupon(coupon)

# Delete all coupons for a promotion
{:ok, count} = Tpe.Coupon.Delete.delete_by_promo_id(promo_id)

# Soft delete (deactivate) coupons
{:ok, count} = Tpe.Coupon.Delete.soft_delete_by_promo_id(promo_id)

# Clean up expired coupons
{:ok, count} = Tpe.Coupon.Delete.cleanup_expired_coupons()
```

## Rule Engine

The rule engine consists of two main components: `Tpe.Rule` for managing promotion rules and `Tpe.RulePart` for managing the individual components of rules.

### Rule Management (`Tpe.Rule`)

#### Create (`Tpe.Rule.Create`)
Create promotion rules with names and descriptions.

```elixir
# Create a new rule
{:ok, rule} = Tpe.Rule.Create.create_rule(%{
  name: "Summer Sale",
  description: "20% off all summer items"
})
```

#### Read (`Tpe.Rule.Read`)
Retrieve and validate rules.

```elixir
# Get rule by ID
{:ok, rule} = Tpe.Rule.Read.get_rule(rule_id)

# Get all valid rule IDs
valid_ids = Tpe.Rule.Read.get_all_valid_ids()

# Get rule with associated rule parts
{:ok, %{rule: rule, rule_parts: parts}} = Tpe.Rule.Read.get_rule_and_rule_parts(rule_id)
```

#### Update (`Tpe.Rule.Update`)
Modify existing rules.

```elixir
# Update rule attributes
{:ok, updated_rule} = Tpe.Rule.Update.update_rule(rule, %{
  name: "Winter Sale",
  description: "Updated promotion details"
})
```

#### Delete (`Tpe.Rule.Delete`)
Remove rules and associated components.

```elixir
# Delete a rule
{:ok, deleted_rule} = Tpe.Rule.Delete.delete_rule(rule)
```

### Rule Parts (`Tpe.RulePart`)

Rule parts define the conditions and actions of a promotion rule.

#### Create (`Tpe.RulePart.Create`)
Create a rule part to be added to a rule

```elixir
# Create a basic rule part
{:ok, rule_part} = Tpe.RulePart.Create.create_rule_part(%{
  rule_id: rule.id,
  block: "tester block",
  verb: "verb",
  arguments: %{}
})

# Create a generator rule part
{:ok, generator} = Tpe.RulePart.Create.generator_rule_part(
  rule.id,
  :item,
  :base_total,
  :base_total
)

# Create a preparation rule part
{:ok, prep} = Tpe.RulePart.Create.prep_rule_part(
  rule.id,
  "forall",
  "has",
  :item,
  :price,
  :price
)
```

#### Read (`Tpe.RulePart.Read`)
Query and validate rule parts.

```elixir
# Get rule part by ID
{:ok, rule_part} = Tpe.RulePart.Read.get_rule_part(part_id)

# Get all rule parts for a rule
rule_parts = Tpe.RulePart.Read.list_rule_parts_by_rule_id(rule_id)

# Get processed rule parts
processed_parts = Tpe.RulePart.Read.get_processed_rule_parts(rule_id)
```

#### Delete (`Tpe.RulePart.Delete`)
Remove rule components.

```elixir
# Delete a single rule part
{:ok, deleted_part} = Tpe.RulePart.Delete.delete_rule_part(part_id)

# Delete all parts for a rule
{count, _} = Tpe.RulePart.Delete.delete_rule_parts_by_rule_id(rule_id)
```
