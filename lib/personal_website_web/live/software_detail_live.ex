defmodule PersonalWebsiteWeb.SoftwareDetailLive do
  use PersonalWebsiteWeb, :live_view
  alias PersonalWebsite.Content

  def mount(%{"slug" => slug}, _session, socket) do
    case Content.get("projects", slug) do
      nil ->
        {:ok, assign(socket,
          proj: nil,
          page_title: "Project not found — Software",
          meta_description: "This software project could not be found."
        )}

      proj ->
        {:ok, assign(socket,
          proj: proj,
          page_title: "#{proj.title} — Software",
          meta_description: proj.summary || "Software project by Pablo Grobas Illobre."
        )}
    end
  end

  def render(%{proj: nil} = assigns) do
    ~H"""
    <div class="max-w-3xl mx-auto p-6">
      <h1 class="text-2xl font-semibold mb-4">Project not found</h1>
      <p><a class="underline" href={~p"/software"}>Back to Software</a></p>
    </div>
    """
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-3xl mx-auto p-6 space-y-4">
      <h1 class="text-3xl font-semibold"><%= @proj.title %></h1>

      <%= if @proj.summary do %>
        <p class="text-gray-700"><%= @proj.summary %></p>
      <% end %>

      <%= if @proj.impact do %>
        <p class="text-sm text-gray-600">Impact: <%= @proj.impact %></p>
      <% end %>

      <div class="flex gap-4 text-sm">
        <%= if @proj.links["code"] do %><a class="underline" href={@proj.links["code"]}>Code</a><% end %>
        <%= if @proj.links["docs"] do %><a class="underline" href={@proj.links["docs"]}>Docs</a><% end %>
        <%= if @proj.links["benchmarks"] do %><a class="underline" href={@proj.links["benchmarks"]}>Benchmarks</a><% end %>
      </div>

      <%= if @proj.tags != [] do %>
        <div class="flex flex-wrap gap-2">
          <%= for t <- @proj.tags do %>
            <span class="text-xs bg-gray-100 rounded px-2 py-0.5"><%= t %></span>
          <% end %>
        </div>
      <% end %>

      <div class="prose max-w-none" dangerously_set_inner_html={@proj.html}></div>

      <p class="pt-4">
        <a class="underline" href={~p"/software"}>← Back to all software</a>
      </p>
    </div>
    """
  end
end
