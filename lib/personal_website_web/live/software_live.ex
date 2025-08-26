 # Defines the LiveView module for the /software route.
defmodule PersonalWebsiteWeb.SoftwareLive do
  # Tells Phoenix this is a LiveView and lets us call Content.list("projects").
  use PersonalWebsiteWeb, :live_view
  alias PersonalWebsite.Content

  # Runs when the page loads — it (It's automatically called when the LiveView loads):
  # Phoenix makes @projects available inside your render template, like this 
  # Fetches your .md files from priv/content/projects
  # Assigns them to @projects
  #
  # The socket is your LiveView's state container + browser connection
  def mount(_params, _session, socket) do
    {:ok, assign(socket, projects: Content.list("projects"))}
  end

  # This is your page layout, using HEEx (HTML + Elixir):
  #   Loops over each project (for p <- @projects)
  #   Displays its title, summary, impact, links, tags
  #   Uses Tailwind CSS classes for layout and styling

  #
  # Phoenix makes @projects available inside your render template, like this
  #
  #
  # def render(assigns) do
  # ~H"""
  # <h1>My Projects</h1>
  # <%= for p <- @projects do %>
  #   <p><%= p.title %></p>
  # <% end %>
  # """
  # end
  #
  def render(assigns) do
    ~H"""
    <div class="max-w-5xl mx-auto p-6">
      <h1 class="text-3xl font-semibold mb-4">Software & Projects</h1>
      <div class="grid md:grid-cols-2 gap-4">
        <%= for p <- @projects do %>
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
