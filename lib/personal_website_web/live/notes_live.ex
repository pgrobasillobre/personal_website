defmodule PersonalWebsiteWeb.NotesLive do
  use PersonalWebsiteWeb, :live_view
  alias PersonalWebsite.Content

  def mount(_params, _session, socket) do
    {:ok, assign(socket, notes: Content.list("notes"))}
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-3xl mx-auto p-6">
      <h1 class="text-3xl font-semibold mb-4">Lab Notebook</h1>
      <ul class="space-y-3">
        <%= for n <- @notes do %>
          <li>
            <a class="text-lg underline" href={~p"/notes/#{n.slug}"}><%= n.title %></a>
            <%= if n.date do %>
              <span class="text-sm text-gray-600"> · <%= Date.to_iso8601(n.date) %></span>
            <% end %>
            <%= if n.summary do %>
              <div class="text-gray-600"><%= n.summary %></div>
            <% end %>
          </li>
        <% end %>
      </ul>
    </div>
    """
  end
end
