defmodule PersonalWebsiteWeb.PageController do
  use PersonalWebsiteWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
