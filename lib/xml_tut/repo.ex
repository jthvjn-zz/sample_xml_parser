defmodule Xmltut.Repo do
  use Ecto.Repo,
    otp_app: :xmltut,
    adapter: Ecto.Adapters.Postgres
end
