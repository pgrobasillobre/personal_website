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
    <div class="pgi-section">

      <a href={~p"/software"} class="pgi-cv-footer-link" style="margin-top:0;margin-bottom:2rem;display:inline-block;">
        ← All software
      </a>


      <%= if @proj.image do %>
        <div style="margin-bottom:2rem;border:1px solid var(--border);border-radius:4px;overflow:hidden;background:#090d14;">
          <img
            src={@proj.image}
            alt={@proj.title}
            style="width:100%;height:auto;display:block;object-fit:contain;"
            loading="lazy"
          />
        </div>
      <% end %>

      <h1 style="font-family:var(--serif);font-size:clamp(2rem,5vw,3rem);font-weight:400;color:var(--text);margin-bottom:1rem;">
        {@proj.title}
      </h1>

      <%= if @proj.summary do %>
        <p style="color:var(--muted);font-size:0.95rem;line-height:1.75;margin-bottom:1rem;max-width:72ch;">
          {@proj.summary}
        </p>
      <% end %>

      <%= if @proj.impact do %>
        <p style="color:var(--accent);font-size:0.85rem;line-height:1.6;margin-bottom:1.25rem;max-width:72ch;">
          {@proj.impact}
        </p>
      <% end %>

      <div style="display:flex;flex-wrap:wrap;gap:0.4rem;margin-bottom:1.25rem;">
        <%= for t <- @proj.tags do %>
          <span class="pgi-sw-tag">{t}</span>
        <% end %>
      </div>

      <div class="pgi-sw-links" style="margin-bottom:2rem;">
        <%= if @proj.links["docs"] do %>
          <a href={@proj.links["docs"]} target="_blank" rel="noopener noreferrer">Docs</a>
        <% end %>
        <%= if @proj.links["code"] do %>
          <a href={@proj.links["code"]} target="_blank" rel="noopener noreferrer">Code</a>
        <% end %>
        <%= if @proj.links["code_cpp"] do %>
          <a href={@proj.links["code_cpp"]} target="_blank" rel="noopener noreferrer">C++ Code</a>
        <% end %>
        <%= if @proj.links["code_fortran"] do %>
          <a href={@proj.links["code_fortran"]} target="_blank" rel="noopener noreferrer">Fortran Code</a>
        <% end %>
        <%= if @proj.links["publication"] do %>
          <a href={@proj.links["publication"]} target="_blank" rel="noopener noreferrer">Publication</a>
        <% end %>
        <%= if @proj.links["benchmarks"] do %>
          <a href={@proj.links["benchmarks"]} target="_blank" rel="noopener noreferrer">Benchmarks</a>
        <% end %>
      </div>

      <hr class="pgi-divider" style="margin-bottom:2rem;" />

      <div
        id="article-body"
        phx-hook="RenderMath"
        class="prose prose-invert max-w-none"
      >
        {Phoenix.HTML.raw(@proj.html || "")}
      </div>

    </div>
    """
  end
end
