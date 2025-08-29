defmodule PersonalWebsiteWeb.PublicationsLive do
  use PersonalWebsiteWeb, :live_view
  alias PersonalWebsite.Content

  def mount(_params, _session, socket) do
    pubs = Content.list("publications")
    {:ok, assign(socket, pubs: pubs)}
  end

  def render(assigns) do
    ~H"""
    <section class="relative isolate overflow-hidden">
      <!-- gradient background -->
      <div aria-hidden="true"
          class="pointer-events-none absolute inset-0 -z-10
                  bg-[radial-gradient(1400px_700px_at_50%_-10%,#e0f2fe_0%,transparent_72%)]">
      </div>

      <div class="max-w-7xl mx-auto p-4">
        <h1 class="text-3xl font-semibold mb-4">Publications</h1>

        <ul class="space-y-5">
          <%= for p <- @pubs do %>
            <li class="group rounded-2xl border border-sky-200 bg-white shadow
                      hover:bg-gradient-to-br hover:from-sky-50 hover:to-indigo-50
                      hover:shadow-md hover:border-sky-300 transition
                      flex gap-4 p-4">
              <%= if p.image do %>
                <!-- Clickable TOC image on the left -->
                <a href={~p"/publications/#{p.slug}"} class="shrink-0 self-center">
                  <img
                    src={p.image}
                    alt={"TOC graphic for " <> p.title}
                    class="max-w-[16rem] md:max-w-[24rem] h-auto border group-hover:opacity-95 transition"
                    loading="lazy"
                  />
                </a>
              <% end %>

              <!-- Text/content on the right -->
              <div class="min-w-0">
                <div class="flex flex-wrap items-baseline gap-2">
                  <a class="text-xl font-medium underline" href={~p"/publications/#{p.slug}"}><%= p.title %></a>
                  <%= if p.date do %><span class="text-sm text-gray-600">(<%= p.date.year %>)</span><% end %>
                </div>

                <%= if p.summary do %>
                  <p class="mt-1 text-justify"><%= p.summary %></p>
                <% end %>

                <div class="mt-2 text-sm text-gray-700">
                  <%= if p.venue do %><span><%= p.venue %></span><% end %>
                  <%= if p.tags != [] do %>
                    · <%= for {t, i} <- Enum.with_index(p.tags) do %>
                      <%= if i > 0, do: ", " %><%= t %>
                    <% end %>
                  <% end %>
                </div>

                <div class="mt-3 flex gap-3">
                  <%= if p.links["doi"] do %>
                    <a class="underline" href={p.links["doi"]} target="_blank" rel="noopener noreferrer">
                      Read the article →
                    </a>
                  <% end %>
                </div>
              </div>
            </li>
          <% end %>
        </ul>
      </div>
    </section>
    """
  end
end
