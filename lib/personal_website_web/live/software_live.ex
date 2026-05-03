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
    <div class="pgi-section">
      <h1 style="font-family:var(--serif);font-size:clamp(2rem,5vw,3.2rem);font-weight:400;color:var(--text);margin-bottom:2rem;">
        Software
      </h1>

      <div style="display:flex;flex-wrap:wrap;gap:0.5rem;margin-bottom:2rem;">
        <button phx-click="clear_tags" class="pgi-tag-btn">Clear all</button>
        <%= for tag <- @tags do %>
          <button
            phx-click="toggle_tag"
            phx-value-tag={tag}
            class={"pgi-tag-btn" <> if(tag in @selected_tags, do: " active", else: "")}
          >
            {tag}
          </button>
        <% end %>
      </div>

      <div class="pgi-sw-list">
        <%= for {p, i} <- Enum.with_index(Enum.filter(@projects, fn p ->
              @selected_tags == [] or Enum.any?(p.tags, &(&1 in @selected_tags))
            end)) do %>
          <div class="pgi-sw-entry">
            <div>
              <a href={~p"/software/#{p.slug}"} class="pgi-sw-entry-title">{p.title}</a>
              <p class="pgi-sw-entry-summary">{p.summary}</p>
              <%= if p.impact do %>
                <p class="pgi-sw-entry-impact">{p.impact}</p>
              <% end %>
              <div class="pgi-sw-entry-meta">
                <div class="pgi-sw-tags">
                  <%= for t <- p.tags do %>
                    <span class="pgi-sw-tag">{t}</span>
                  <% end %>
                </div>
                <div class="pgi-sw-links">
                  <%= if p.links["docs"] do %>
                    <a href={p.links["docs"]} target="_blank" rel="noopener noreferrer">Docs</a>
                  <% end %>
                  <%= if p.links["code"] do %>
                    <a href={p.links["code"]} target="_blank" rel="noopener noreferrer">Code</a>
                  <% end %>
                  <%= if p.links["code_cpp"] do %>
                    <a href={p.links["code_cpp"]} target="_blank" rel="noopener noreferrer">C++ Code</a>
                  <% end %>
                  <%= if p.links["code_fortran"] do %>
                    <a href={p.links["code_fortran"]} target="_blank" rel="noopener noreferrer">Fortran Code</a>
                  <% end %>
                  <%= if p.links["publication"] do %>
                    <a href={p.links["publication"]} target="_blank" rel="noopener noreferrer">Publication</a>
                  <% end %>
                  <%= if p.links["benchmarks"] do %>
                    <a href={p.links["benchmarks"]} target="_blank" rel="noopener noreferrer">Benchmarks</a>
                  <% end %>
                </div>
              </div>
            </div>
            <a href={~p"/software/#{p.slug}"} class="pgi-sw-arrow" tabindex="-1">↗</a>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
