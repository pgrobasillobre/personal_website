defmodule PersonalWebsiteWeb.Plugs.CanonicalHost do
  import Plug.Conn
  alias Phoenix.Controller

  @canonical "pgrobasillobre.com"

  def init(opts), do: opts

  def call(%Plug.Conn{host: @canonical} = conn, _opts), do: conn

  def call(conn, _opts) do
    qs = if conn.query_string in [nil, ""], do: "", else: "?" <> conn.query_string
    location = "https://#{@canonical}#{conn.request_path}#{qs}"

    conn
    |> Plug.Conn.put_resp_header("location", location)
    |> Plug.Conn.send_resp(301, "redirect")
    |> Plug.Conn.halt()
  end
end
