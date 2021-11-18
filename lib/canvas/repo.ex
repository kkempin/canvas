defmodule Canvas.Repo do
  use Ecto.Repo,
    otp_app: :canvas,
    adapter: Ecto.Adapters.Postgres
end
