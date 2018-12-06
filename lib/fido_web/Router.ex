defmodule FidoWeb.Router do
  use Plug.Router
  require Logger

  plug :match
  plug :dispatch

  get("/ping") do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Pong")
  end

  match(_) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(404, "Not Found")
  end
end
