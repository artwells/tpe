defmodule Tpe.TestTools do
  def sandbox_connection() do
    Ecto.Adapters.SQL.Sandbox.checkout(Tpe.Repo)
  end
end
