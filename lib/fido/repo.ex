defmodule Fido.Repo do
  use Ecto.Repo,
    otp_app: :fido,
    adapter: Ecto.Adapters.Postgres
end
