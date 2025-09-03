defmodule PersonalWebsiteWeb.PublicationsLive do
  use PersonalWebsiteWeb, :live_view
  alias PersonalWebsite.Content

  ## ---------------------------------------------------------------------
  ## Mount: load publications and set abstract modal state to nil (closed)
  ## ---------------------------------------------------------------------
  def mount(_params, _session, socket) do
    pubs = Content.list("publications")
    {:ok, assign(socket, pubs: pubs, active_pub: nil)}
  end

  ## -----------------------------------------------------------
  ## Events: open/close the abstract modal
  ## -----------------------------------------------------------

  # Open the modal by storing the selected pub in :active_pub
  @spec handle_event(<<_::64, _::_*8>>, any(), any()) :: {:noreply, any()}
  def handle_event("open_abstract", %{"slug" => slug}, socket) do
    pub = Enum.find(socket.assigns.pubs, &(&1.slug == slug))
    {:noreply, assign(socket, active_pub: pub)}
  end

  # Close the modal by resetting :active_pub
  def handle_event("close_abstract", _params, socket) do
    {:noreply, assign(socket, active_pub: nil)}
  end

  ## -----------------------------------------------------------
  ## Render: list of publications + modal (when active_pub is set)
  ## -----------------------------------------------------------
  def render(assigns) do
    ~H"""
    <!-- gradient background -->
    <div aria-hidden="true"
        class="pointer-events-none absolute inset-0 -z-10
                bg-[radial-gradient(1400px_700px_at_50%_-10%,#e0f2fe_0%,transparent_72%)]">
    </div>
    <section class="relative isolate overflow-hidden">
      <div class="max-w-7xl mx-auto p-4">
        <h1 class="text-5xl font-semibold mt-6 mb-6">Publications</h1>

        <ul class="space-y-5">
          <%= for p <- @pubs do %>
            <!-- Card: blue frame + subtle blue hover; flex so TOC sits left of text -->
            <li class="group rounded-2xl border border-sky-200 bg-white shadow
                       hover:bg-gradient-to-br hover:from-sky-50 hover:to-indigo-50
                       hover:shadow-md hover:border-sky-300 transition
                       flex gap-4 p-4">

              <!-- Optional TOC image on the left; now opens the modal -->
              <%= if p.image do %>
                <button
                  type="button"
                  phx-click="open_abstract"
                  phx-value-slug={p.slug}
                  class="shrink-0 self-center">
                  <img
                    src={p.image}
                    alt={"TOC graphic for " <> p.title}
                    class="max-w-[16rem] md:max-w-[24rem] h-auto group-hover:opacity-95 transition"
                    loading="lazy"
                  />
                </button>
              <% end %>

              <!-- Text/content on the right -->
              <div class="min-w-0">
                <div class="flex flex-wrap items-baseline gap-2">
                  <!-- Title now opens the modal instead of navigating -->
                  <button
                    type="button"
                    phx-click="open_abstract"
                    phx-value-slug={p.slug}
                    class="text-xl text-left underline text-xl font-medium">
                    <%= p.title %>,
                  </button>

                  <!-- Journal and date -->
                  <%= if p.venue do %>
                    <p class="text-lg text-gray-700"><%= p.venue %> <span>(<%= p.date.year %>)</span> </p>
                  <% end %>
                </div>

                <!-- Authors (highlight your name) -->
                <%= if (p.authors || []) != [] do %>
                  <div class="mt-1 text-lg text-gray-700">
                    <%= for {a, i} <- Enum.with_index(p.authors) do %>
                      <%= if i > 0, do: ", " %>
                      <%= if a == "P. Grobas Illobre" do %>
                        <span class="font-semibold underline"><%= a %></span>
                      <% else %>
                        <span><%= a %></span>
                      <% end %>
                    <% end %>
                  </div>
                <% end %>

                <!-- TL;DR shown in list-->
                <%= if p.summary do %>
                  <p class="mt-5 text-xl text-justify"><%= p.summary %></p>
                <% end %>

                <div class="mt-5 text-lg text-gray-700">
                  <%= if p.tags != [] do %>
                    <%= for {t, i} <- Enum.with_index(p.tags) do %>
                      <%= if i > 0, do: " ·  " %><%= t %>
                    <% end %>
                  <% end %>
                </div>

                <!-- Actions: Abstract opens modal; DOI still available here -->
                <div class="mt-5 flex gap-3">
                  <button
                    phx-click="open_abstract"
                    phx-value-slug={p.slug}
                    class="text-xl underline"
                    type="button">
                    Abstract
                  </button>

                  <%= if p.links["doi"] do %>
                    <a class="text-xl underline" href={p.links["doi"]} target="_blank" rel="noopener noreferrer">
                      Read the article →
                    </a>
                  <% end %>
                </div>
              </div>
            </li>
          <% end %>
        </ul>
      </div>

      <%= if @active_pub do %>
        <!-- Backdrop: purely visual; blur + dim -->
        <div class="fixed inset-0 z-50 bg-black/40 backdrop-blur-sm"></div>

        <!-- Centered modal panel -->
        <div class="fixed inset-0 z-50 flex items-center justify-center p-8">
          <div
              role="dialog"
              aria-modal="true"
              aria-label="Publication abstract"
              class="w-full max-w-5xl max-h-[85vh] overflow-y-auto
                        bg-white rounded-2xl border border-sky-200 shadow-xl"
              phx-click-away="close_abstract"
              phx-window-keydown="close_abstract"
              phx-key="escape"
            >

          <!-- Close button (top-right) -->
          <div class="flex justify-end p-2">
            <button
              phx-click="close_abstract"
              type="button"
              class="rounded-full p-1.5 hover:bg-sky-50 border border-sky-500"
              aria-label="Close">
              X
            </button>
          </div>

            <%= if @active_pub.image do %>
              <img
                src={@active_pub.image}
                alt={"TOC graphic for " <> @active_pub.title}
                class="w-full h-auto object-contain"
                loading="lazy"
              />
            <% end %>


            <div class="p-5 space-y-3">
            <!-- Title + venue + year, inline but with different fonts -->
            <div class="text-xl font-semibold">
              <%= @active_pub.title %>,
              <%= if @active_pub.venue do %>
                <span class="text-xl text-gray-700">
                  <%= @active_pub.venue %><%= if @active_pub.date, do: " (#{@active_pub.date.year})" %>
                </span>
              <% end %>
            </div>

              <!-- Authors (highlight your name) -->
              <%= if ( @active_pub.authors || [] ) != [] do %>
                <div class="text-xl text-gray-700">
                  <%= for {a, i} <- Enum.with_index(@active_pub.authors) do %>
                    <%= if i > 0, do: ", " %>
                    <%= if a == "P. Grobas Illobre" do %>
                      <span class="font-semibold underline"><%= a %></span>
                    <% else %>
                      <span><%= a %></span>
                    <% end %>
                  <% end %>
                </div>
              <% end %>

              <!-- Prefer abstract; fallback to summary -->
              <%= if @active_pub.abstract do %>
                <p class="text-xl text-gray-700 text-justify"><%= @active_pub.abstract %></p>
              <% else %>
                <%= if @active_pub.summary do %>
                  <p class="text-gray-700 text-justify"><%= @active_pub.summary %></p>
                <% end %>
              <% end %>

              <div class="pt-2">
                <%= if @active_pub.links["doi"] do %>
                  <a href={@active_pub.links["doi"]}
                    target="_blank" rel="noopener noreferrer"
                    class="text-xl inline-flex items-center gap-1 underline">
                    Read the article →
                  </a>
                <% end %>
              </div>
            </div>
          </div>
        </div>

      <% end %>
    </section>
    """
  end
end
