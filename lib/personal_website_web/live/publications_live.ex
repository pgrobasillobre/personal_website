defmodule PersonalWebsiteWeb.PublicationsLive do
  use PersonalWebsiteWeb, :live_view
  alias PersonalWebsite.Content

  def mount(_params, _session, socket) do
    pubs = Content.list("publications")
    {:ok, assign(socket, pubs: pubs, active_pub: nil)}
  end

  def handle_event("open_abstract", %{"slug" => slug}, socket) do
    pub = Enum.find(socket.assigns.pubs, &(&1.slug == slug))
    {:noreply, assign(socket, active_pub: pub)}
  end

  def handle_event("close_abstract", _params, socket) do
    {:noreply, assign(socket, active_pub: nil)}
  end

  def render(assigns) do
    ~H"""
    <div class="pgi-section">
      <h1 style="font-family:var(--serif);font-size:clamp(2rem,5vw,3.2rem);font-weight:400;color:var(--text);margin-bottom:2.5rem;">
        Publications
      </h1>

      <div class="pgi-pub-list">
        <%= for p <- @pubs do %>
          <div class="pgi-pub-item-row">
            <div>
              <%= if p.venue do %>
                <div class="pgi-pub-journal">
                  {p.venue}<%= if p.date do %> · {p.date.year}<% end %>
                </div>
              <% end %>
              <button
                type="button"
                phx-click="open_abstract"
                phx-value-slug={p.slug}
                class="pgi-pub-title-btn pgi-desktop-only"
              >
                {p.title}
              </button>
              <a
                href={p.links["doi"]}
                target="_blank"
                rel="noopener noreferrer"
                class="pgi-pub-title-btn pgi-mobile-only"
              >
                {p.title}
              </a>
              <%= if (p.authors || []) != [] do %>
                <div class="pgi-pub-authors">
                  <%= for {a, i} <- Enum.with_index(p.authors) do %>
                    {if i > 0, do: ", "}
                    <span class={if a == "P. Grobas Illobre", do: "self", else: ""}>{a}</span>
                  <% end %>
                </div>
              <% end %>
              <%= if p.summary do %>
                <div class="pgi-pub-abstract">{p.summary}</div>
              <% end %>
            </div>
            <%= if p.links["doi"] do %>
              <a
                href={p.links["doi"]}
                target="_blank"
                rel="noopener noreferrer"
                class="pgi-pub-arrow"
              >↗</a>
            <% end %>
          </div>
        <% end %>
      </div>

      <%= if @active_pub do %>
        <div class="pgi-modal-backdrop" phx-click="close_abstract"></div>
        <div class="pgi-modal-wrap">
          <div
            role="dialog"
            aria-modal="true"
            aria-label="Publication abstract"
            class="pgi-modal"
            phx-click-away="close_abstract"
            phx-window-keydown="close_abstract"
            phx-key="escape"
          >
            <div class="pgi-modal-header">
              <button phx-click="close_abstract" type="button" class="pgi-modal-close">
                Close
              </button>
            </div>
            <%= if @active_pub.image do %>
              <img
                src={@active_pub.image}
                alt={"TOC graphic for " <> @active_pub.title}
                style="width:100%;height:auto;object-fit:contain;"
                loading="lazy"
              />
            <% end %>
            <div class="pgi-modal-body">
              <%= if @active_pub.venue do %>
                <div class="pgi-pub-journal">
                  {@active_pub.venue}<%= if @active_pub.date do %> · {@active_pub.date.year}<% end %>
                </div>
              <% end %>
              <div style="font-family:var(--serif);font-size:clamp(1rem,2.2vw,1.2rem);font-weight:400;line-height:1.3;color:var(--text);margin-bottom:0.8rem;">
                {@active_pub.title}
              </div>
              <%= if (@active_pub.authors || []) != [] do %>
                <div class="pgi-pub-authors" style="margin-bottom:1rem;">
                  <%= for {a, i} <- Enum.with_index(@active_pub.authors) do %>
                    {if i > 0, do: ", "}
                    <span class={if a == "P. Grobas Illobre", do: "self", else: ""}>{a}</span>
                  <% end %>
                </div>
              <% end %>
              <%= if @active_pub.abstract do %>
                <p class="pgi-pub-abstract" style="font-size:0.85rem;line-height:1.7;">
                  {@active_pub.abstract}
                </p>
              <% else %>
                <%= if @active_pub.summary do %>
                  <p class="pgi-pub-abstract" style="font-size:0.85rem;line-height:1.7;">
                    {@active_pub.summary}
                  </p>
                <% end %>
              <% end %>
              <%= if @active_pub.links["doi"] do %>
                <a
                  href={@active_pub.links["doi"]}
                  target="_blank"
                  rel="noopener noreferrer"
                  class="pgi-modal-doi"
                >
                  Read article →
                </a>
              <% end %>
            </div>
          </div>
        </div>
      <% end %>
    </div>
    """
  end
end
