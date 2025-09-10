defmodule PersonalWebsiteWeb.Plugs.CanonicalHost do
  import Plug.Conn

  @canonical "pgrobasillobre.com"

  def init(opts), do: opts

  # Already on apex → do nothing
  def call(%Plug.Conn{host: @canonical} = conn, _opts), do: conn

  # Any other host (www, fly.dev, etc.) → 301 to https://apex
  def call(conn, _opts) do
    qs = if conn.query_string in [nil, ""], do: "", else: "?" <> conn.query_string
    location = "https://#{@canonical}#{conn.request_path}#{qs}"

    conn
    |> put_resp_header("location", location)
    |> put_resp_header("x-canonical-redirect", "1")   # debug header
    |> send_resp(301, "redirect")
    |> halt()
  end
end
