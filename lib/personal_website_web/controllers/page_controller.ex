defmodule PersonalWebsiteWeb.PageController do
  use PersonalWebsiteWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end

  # debugpgi
  # Classic controller for static or simple pages (non-LiveView).
  # Renders templates like about.html.heex via render/2.
  # Used for non-interactive routes like "/about".
  def about(conn, _params), do: render(conn, :about)

end
