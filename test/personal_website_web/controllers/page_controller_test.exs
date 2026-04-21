defmodule PersonalWebsiteWeb.PageControllerTest do
  use PersonalWebsiteWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    document = html_response(conn, 200) |> LazyHTML.from_document()

    assert document |> LazyHTML.query_by_id("home-hero") |> Enum.count() == 1
    assert document |> LazyHTML.query_by_id("home-hero-cv") |> Enum.count() == 1
    assert document |> LazyHTML.query_by_id("home-proof") |> Enum.count() == 1
  end
end
