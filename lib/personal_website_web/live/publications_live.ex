defmodule PersonalWebsiteWeb.PublicationsLive do
  use PersonalWebsiteWeb, :live_view
  alias PersonalWebsite.Content

  def mount(_params, _session, socket) do
    pubs = Content.list("publications")
    {:ok, assign(socket, pubs: pubs)}
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-4xl mx-auto p-6">
      <h1 class="text-3xl font-semibold mb-4">Publications (curated)</h1>
      <ul class="space-y-5">
        <%= for p <- @pubs do %>
          <li class="rounded-2xl shadow p-4">
            <div class="flex flex-wrap items-baseline gap-2">
              <a class="text-xl font-medium underline" href={~p"/publications/#{p.slug}"}><%= p.title %></a>
              <%= if p.date do %><span class="text-sm text-gray-600">(<%= p.date.year %>)</span><% end %>
            </div>
            <%= if p.summary do %><p class="mt-1"><%= p.summary %></p><% end %>
            <div class="mt-2 text-sm text-gray-700">
              <%= if p.venue do %><span><%= p.venue %></span><% end %>
              <%= if p.tags != [] do %>
                · <%= for {t, i} <- Enum.with_index(p.tags) do %>
                  <%= if i > 0, do: ", " %><%= t %>
                <% end %>
              <% end %>
            </div>
            <div class="mt-3 flex gap-3">
              <%= if p.links["doi"] do %><a class="underline" href={p.links["doi"]}>DOI</a><% end %>
              <%= if p.links["pdf"] do %><a class="underline" href={p.links["pdf"]}>PDF</a><% end %>
            </div>
          </li>
        <% end %>
      </ul>
    </div>
    """
  end
end
