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
git clone git@github.com:artwells/pe.git

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

- Coupon management via GenServer
- Rule engine using Wongi
- PostgreSQL for persistence
- Ecto for database interactions


## Project Structure

```
lib/
    tpe/
        coupon/     # Coupon management
        engine/     # Rule engine
        repo.ex     # Database interface
```