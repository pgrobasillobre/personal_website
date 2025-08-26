defmodule PersonalWebsiteWeb.HomeLive do
  use PersonalWebsiteWeb, :live_view
  alias PersonalWebsite.Content

  # assign(socket, [key1: val1, key2: val2]) is valid shorthand!
  def mount(_params, _session, socket) do
    assigns = [
      page_title: "Pablo Grobas Illobre — Computational Chemist & Scientific Software Developer",
      meta_description: "Projects, publications, and notes. Now: " <> Enum.join(PersonalWebsite.Content.now(), " "),
      now: Content.now(),
      notes: PersonalWebsite.Content.list("notes") |> Enum.take(3), # include last three notes
      projects: Content.list("projects") |> Enum.take(1) # top highlight
    ]
    {:ok, assign(socket, assigns)}
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-5xl mx-auto p-6 space-y-10">
      <section>
        <h1 class="text-4xl font-bold">Pablo Grobas Illobre</h1>
        <p class="mt-2 text-lg">Computational chemist building high-performance scientific software (Python · C++ · Fortran).</p>
        <div class="mt-4 flex gap-3">
          <a href="/cv.pdf" class="px-4 py-2 rounded-2xl bg-gray-900 text-white shadow">Download CV</a>
          <a href="mailto:you@example.com" class="px-4 py-2 rounded-2xl bg-gray-100 shadow">Contact</a>
        </div>
        <p class="mt-3 text-sm text-gray-600">Pisa · Remote-friendly · Open to roles</p>
      </section>

      <section>
        <h2 class="text-2xl font-semibold mb-2">Now</h2>
        <ul class="list-disc ml-6 space-y-1">
          <%= for item <- @now do %><li><%= item %></li><% end %>
        </ul>
      </section>

      <section>
        <h2 class="text-2xl font-semibold mb-4">Highlight</h2>
        <div class="grid md:grid-cols-2 gap-4">
          <%= for p <- @projects do %>
            <div class="rounded-2xl shadow p-4">
              <!-- debugpgi: make highlight project title clickable (links to /software/:slug) -->
              <h3 class="text-xl font-medium">
                <a class="underline" href={~p"/software/#{p.slug}"}><%= p.title %></a>
              </h3>

              <p class="mt-1"><%= p.summary %></p>
              <%= if p.impact do %><p class="mt-2 text-sm text-gray-600">Impact: <%= p.impact %></p><% end %>
              <div class="mt-3 flex gap-3">
                <%= if p.links["code"] do %><a class="underline" href={p.links["code"]}>Code</a><% end %>
                <%= if p.links["docs"] do %><a class="underline" href={p.links["docs"]}>Docs</a><% end %>
              </div>
            </div>
          <% end %>
        </div>
      </section>

      <section>
        <h2 class="text-2xl font-semibold mb-2">Recent notes</h2>
        <ul class="space-y-2">
          <%= for n <- @notes do %>
            <li>
              <a class="underline" href={~p"/notes/#{n.slug}"}><%= n.title %></a>
              <%= if n.summary do %><span class="text-gray-600"> — <%= n.summary %></span><% end %>
            </li>
          <% end %>
        </ul>
      </section>
    </div>
    """
  end
end
