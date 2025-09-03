defmodule PersonalWebsiteWeb.SoftwareDetailLive do
  use PersonalWebsiteWeb, :live_view
  alias PersonalWebsite.Content

  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    case Content.get("projects", slug) do
      nil ->
        {:ok,
         assign(socket,
           proj: nil,
           page_title: "Project not found — Software",
           meta_description: "This software project could not be found."
         )}

      proj ->
        {:ok,
         assign(socket,
           proj: proj,
           page_title: "#{proj.title} — Software",
           meta_description: proj.summary || "Software project by Pablo Grobas Illobre."
         )}
    end
  end

  # IMPORTANT: bind the variable name `assigns`
  @impl true
  def render(%{proj: nil} = assigns) do
    ~H"""
    <div class="max-w-3xl mx-auto p-6">
      <h1 class="text-2xl font-semibold mb-4">Project not found</h1>
      <p><a class="underline" href={~p"/software"}>Back to Software</a></p>
    </div>
    """
  end

  @impl true
  def render(assigns) do
    ~H"""
    <!-- gradient background -->
    <div aria-hidden="true"
         class="pointer-events-none absolute inset-0 -z-10
                bg-[radial-gradient(1400px_700px_at_50%_-10%,#e0f2fe_0%,transparent_72%)]">
    </div>

    <section class="relative isolate overflow-hidden">

      <%= if @proj.image do %>
        <img
          src={@proj.image}
          alt={@proj.title}
          class="mb-6 mt-6 max-w-2xl w-full h-auto mx-auto rounded-lg border hover:opacity-90 transition"
        />
      <% end %>

      <div class="max-w-3xl mx-auto p-6 space-y-4">
        <h1 class="text-3xl font-semibold"><%= @proj.title %></h1>

        <%= if @proj.summary do %>
          <p class="text-gray-700"><%= @proj.summary %></p>
        <% end %>

        <%= if @proj.impact do %>
          <p class="text-sm text-gray-600">Impact: <%= @proj.impact %></p>
        <% end %>

        <div class="flex gap-4 text-sm flex-wrap">
          <%= if @proj.links["code"] do %><a class="underline" href={@proj.links["code"]}>Code</a><% end %>
          <%= if @proj.links["docs"] do %><a class="underline" href={@proj.links["docs"]}>Docs</a><% end %>
          <%= if @proj.links["code_cpp"] do %><a class="underline" href={@proj.links["code_cpp"]}>C++ Code</a><% end %>
          <%= if @proj.links["code_fortran"] do %><a class="underline" href={@proj.links["code_fortran"]}>Fortran Code</a><% end %>
        </div>

        <%= if @proj.tags != [] do %>
          <div class="flex flex-wrap gap-2">
            <%= for t <- @proj.tags do %>
              <span class="text-xs bg-gray-100 rounded px-2 py-0.5"><%= t %></span>
            <% end %>
          </div>
        <% end %>

        <!-- Render HTML from Earmark -->
        <div class="prose max-w-none">
          <%= Phoenix.HTML.raw(@proj.html || "") %>
        </div>

        <p class="pt-4">
          <a class="underline" href={~p"/software"}>← Back to all software</a>
        </p>
      </div>
    </section>
    """
  end
end
