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
      <p><a class="text-2xlunderline" href={~p"/software"}>Back to Software</a></p>
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

    <!-- final-frame image layer, SAME structure as Home's video wrapper -->
    <div aria-hidden="true"
        class="absolute inset-x-0 top-0 h-[clamp(560px,80svh,900px)] -z-20 hero-video-mask opacity-5">
      <img
        src={~p"/videos/molecules-final.jpg"}
        alt=""
        class="absolute inset-0 w-full h-full object-cover object-[50%_40%] select-none pointer-events-none"
        loading="eager"
        decoding="async"
      />
    </div>

    <section class="relative isolate overflow-hidden">
      <!-- Hero image -->
      <%= if @proj.image do %>
        <img
          src={@proj.image}
          alt={@proj.title}
          class="mb-6 mt-6 max-w-3xl w-full h-auto mx-auto rounded-lg border hover:opacity-90 transition"
        />
      <% end %>

      <!-- Single container for header + article -->
      <div class="max-w-5xl mx-auto p-6">
        <!-- Header/meta block -->
        <div class="space-y-4">
          <h1 class="text-4xl font-semibold"><%= @proj.title %></h1>

          <%= if @proj.summary do %>
            <p class="text-lg text-gray-700"><%= @proj.summary %></p>
          <% end %>

          <%= if @proj.impact do %>
            <p class="text-lg text-gray-600">Impact: <%= @proj.impact %></p>
          <% end %>

          <div class="text-lg flex gap-4 text-sm flex-wrap">
            <%= if @proj.links["code"] do %><a class="text-lg  underline" href={@proj.links["code"]}>Code</a><% end %>
            <%= if @proj.links["docs"] do %><a class="text-lg  underline" href={@proj.links["docs"]}>Docs</a><% end %>
            <%= if @proj.links["code_cpp"] do %><a class="text-lg  underline" href={@proj.links["code_cpp"]}>C++ Code</a><% end %>
            <%= if @proj.links["code_fortran"] do %><a class="text-lg  underline" href={@proj.links["code_fortran"]}>Fortran Code</a><% end %>
          </div>

          <%= if @proj.tags != [] do %>
            <div class="flex flex-wrap gap-2">
              <span class="text-base">Tags:</span>
              <%= for t <- @proj.tags do %>
                <span class="mb-8 text-base bg-gray-100 rounded px-2 py-0.5"> <%= t %></span>
              <% end %>
            </div>
          <% end %>
        </div>

      <hr class="my-1 mx-auto max-w-5xl border-t-2 border-gray-800 rounded" />

        <!-- Two-column layout -->
        <div class="mt-8 lg:grid-cols-[220px_minmax(0,1fr)] gap-8">
          <!-- Article -->
          <div
            id="article-body"
            phx-hook="RenderMath"
            class="mb-6 prose prose-slate lg:prose-lg dark:prose-invert max-w-none"
          >
            <%= Phoenix.HTML.raw(@proj.html || "") %>
          </div>

            <p class="pt-6">
              <a class="text-xl underline" href={~p"/software"}>← Back to all software</a>
            </p>
        </div>
      </div>
    </section>
    """
  end
end
