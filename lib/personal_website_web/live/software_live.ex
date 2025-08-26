defmodule PersonalWebsiteWeb.SoftwareLive do
  use PersonalWebsiteWeb, :live_view
  alias PersonalWebsite.Content

  def mount(_params, _session, socket) do
    projects = Content.list("projects")

    tags =
      projects
      |> Enum.flat_map(& &1.tags)
      |> Enum.uniq()
      |> Enum.sort()

    {:ok,
     socket
     |> assign(:projects, projects)
     |> assign(:tags, tags)
     |> assign(:selected_tags, [])}
  end

  def handle_event("toggle_tag", %{"tag" => tag}, socket) do
    selected = socket.assigns.selected_tags

    new_selection =
      if tag in selected do
        List.delete(selected, tag)
      else
        [tag | selected]
      end

    {:noreply, assign(socket, selected_tags: new_selection)}
  end

  def handle_event("clear_tags", _params, socket) do
    {:noreply, assign(socket, selected_tags: [])}
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-5xl mx-auto p-6 space-y-6">
      <h1 class="text-3xl font-semibold">Software & Projects</h1>

      <!-- debugpgi: Multi-tag filtering -->
      <div class="flex flex-wrap gap-2 items-center">
        <button phx-click="clear_tags"
          class="px-3 py-1 rounded-full border text-sm bg-gray-200 hover:bg-gray-300">
          Clear All
        </button>

        <%= for tag <- @tags do %>
          <button
            phx-click="toggle_tag"
            phx-value-tag={tag}
            class={
              "px-3 py-1 rounded-full border text-sm transition " <>
              if tag in @selected_tags, do: "bg-gray-900 text-white", else: "bg-white"
            }>
            <%= tag %>
          </button>
        <% end %>
      </div>

      <!-- debugpgi: Filtered projects -->
      <div class="grid md:grid-cols-2 gap-4">
        <%= for p <- Enum.filter(@projects, fn p ->
              @selected_tags == [] or Enum.any?(p.tags, &(&1 in @selected_tags))
            end) do %>
          <div class="rounded-2xl shadow p-4">
            <h3 class="text-xl font-medium">
              <a class="underline" href={~p"/software/#{p.slug}"}><%= p.title %></a>
            </h3>
            <p class="mt-1"><%= p.summary %></p>
            <%= if p.impact do %>
              <p class="mt-2 text-sm text-gray-600">Impact: <%= p.impact %></p>
            <% end %>
            <div class="mt-3 flex gap-3">
              <%= if p.links["code"] do %><a class="underline" href={p.links["code"]}>Code</a><% end %>
              <%= if p.links["docs"] do %><a class="underline" href={p.links["docs"]}>Docs</a><% end %>
              <%= if p.links["benchmarks"] do %><a class="underline" href={p.links["benchmarks"]}>Benchmarks</a><% end %>
            </div>
            <%= if p.tags != [] do %>
              <div class="mt-3 flex flex-wrap gap-2">
                <%= for t <- p.tags do %>
                  <span class="text-xs bg-gray-100 rounded px-2 py-0.5"><%= t %></span>
                <% end %>
              </div>
            <% end %>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
