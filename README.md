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

## Architecture

- Rule engine using Wongi
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

### Delete (`Tpe.Coupon.Delete`)
- Remove individual coupons
- Bulk deletion options
