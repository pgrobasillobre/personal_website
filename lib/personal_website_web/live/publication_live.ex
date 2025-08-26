defmodule PersonalWebsiteWeb.PublicationLive do
  use PersonalWebsiteWeb, :live_view
  alias PersonalWebsite.Content

  def mount(%{"slug" => slug}, _session, socket) do
  case Content.get("publications", slug) do
    nil -> {:ok, assign(socket, :pub, nil)}
    pub -> {:ok, assign(socket, :pub, pub)}
  end
end

  def render(%{pub: nil} = assigns) do
    ~H"""
    <div class="max-w-3xl mx-auto p-6">
      <h1 class="text-2xl font-semibold mb-4">Publication not found</h1>
      <p><a class="underline" href={~p"/publications"}>Back to list</a></p>
    </div>
    """
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-3xl mx-auto p-6">
      <p class="text-sm text-gray-600">
        <%= if @pub.date, do: Date.to_iso8601(@pub.date) %>
      </p>
      <h1 class="text-3xl font-semibold"><%= @pub.title %></h1>
      <div class="mt-1 text-gray-700">
        <%= if @pub.venue do %><%= @pub.venue %><% end %>
        <%= if @pub.date do %> · <%= @pub.date.year %><% end %>
      </div>
      <div class="mt-4">
        <%= if @pub.summary do %><p><%= @pub.summary %></p><% end %>
        <div class="prose max-w-none mt-4" dangerously_set_inner_html={@pub.html}></div>
      </div>
      <div class="mt-4 flex gap-3">
        <%= if @pub.links["doi"] do %><a class="underline" href={@pub.links["doi"]}>DOI</a><% end %>
        <%= if @pub.links["pdf"] do %><a class="underline" href={@pub.links["pdf"]}>PDF</a><% end %>
      </div>
    </div>
    """
  end
end
