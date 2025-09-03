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

    <!-- gradient background -->
    <div aria-hidden="true"
        class="pointer-events-none absolute inset-0 -z-10
                bg-[radial-gradient(1400px_700px_at_50%_-10%,#e0f2fe_0%,transparent_72%)]">
    </div>
    <section class="relative isolate overflow-hidden">

      <div class="max-w-7xl mx-auto p-6 space-y-6">
        <h1 class="text-5xl font-semibold mt-6 mb-6">Software</h1>

        <!-- debugpgi: Multi-tag filtering -->
        <div class="flex flex-wrap gap-2 items-center">
          <button phx-click="clear_tags"
            class="px-3 py-1 rounded-full border text-base bg-gray-200 hover:bg-gray-300">
            Clear All
          </button>

          <%= for tag <- @tags do %>
            <button
              phx-click="toggle_tag"
              phx-value-tag={tag}
              class={
                "px-3 py-1 rounded-full border text-base transition " <>
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

            <!-- OUTER thick-bordered box -->
            <!-- <div class="p-4 rounded-2xl border border-gray-600 shadow bg-white hover:bg-gray-200 hover:shadow-md transition">  -->
            <div class="p-4 rounded-2xl border border-sky-200 shadow bg-white hover:bg-gradient-to-br hover:from-sky-50 hover:to-indigo-50 hover:shadow-md transition cursor-pointer">

                <%= if p.image do %>
                  <a href={~p"/software/#{p.slug}"}>
                    <img
                      src={p.image}
                      alt={"Screenshot of " <> p.title}
                      class="mb-4 w-full rounded-lg border hover:opacity-90 transition"
                    />
                  </a>
                <% end %>

              <h3 class="text-2xl font-medium">
                <a class="underline" href={~p"/software/#{p.slug}"}><%= p.title %></a>
              </h3>


              <p class="mt-3 text-lg text-justify"><%= p.summary %></p>
              <%= if p.impact do %>
                <p class="mt-2 text-lg  text-base text-gray-600 text-justify">Impact: <%= p.impact %></p>
              <% end %>

              <div class="mt-3 flex gap-3">
                <%= if p.links["code"] do %><a class="text-lg underline" href={p.links["code"]}>Code</a><% end %>

                <!-- Custom for FretLab -->
                <%= if p.links["code_cpp"] do %>
                  <a class="text-lg underline" href={p.links["code_cpp"]}>C++ Code</a>
                <% end %>

                <%= if p.links["code_fortran"] do %>
                  <a class="text-lg underline" href={p.links["code_fortran"]}>Fortran Code</a>
                <% end %>

                <%= if p.links["docs"] do %><a class="text-lg underline" href={p.links["docs"]}>Docs</a><% end %>
                <%= if p.links["benchmarks"] do %><a class="text-lg underline" href={p.links["benchmarks"]}>Benchmarks</a><% end %>
              </div>
              <%= if p.tags != [] do %>
                <div class="mt-3 flex flex-wrap gap-2">
                  <%= for t <- p.tags do %>
                    <span class="mt-2 h-full text-base bg-gray-100 rounded px-2 py-0.5"><%= t %></span>
                  <% end %>
                </div>
              <% end %>
            </div>
          <% end %>
        </div>
      </div>
    </section>
    """
  end
end
