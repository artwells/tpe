defmodule Tpe.TestTools do
  def sandbox_connection() do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Tpe.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Tpe.Repo, {:shared, self()})
  end
end
