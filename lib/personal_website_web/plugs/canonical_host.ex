defmodule PersonalWebsiteWeb.Plugs.CanonicalHost do
  import Plug.Conn
  alias Phoenix.Controller

  @canonical "pgrobasillobre.com"

  def init(opts), do: opts

  def call(%Plug.Conn{host: @canonical} = conn, _opts), do: conn

  def call(conn, _opts) do
    scheme = if conn.scheme == :https, do: "https", else: "http"
    Controller.redirect(conn, external: "#{scheme}://#{@canonical}#{conn.request_path}")
    |> halt()
  end
end
