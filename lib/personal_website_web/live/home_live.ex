defmodule PersonalWebsiteWeb.HomeLive do
  use PersonalWebsiteWeb, :live_view
  alias PersonalWebsite.Content

  def mount(_params, _session, socket) do
    assigns = [
      page_title: "Pablo Grobas Illobre - Computational Chemist & Scientific Software Developer",
      meta_description:
        "Computational chemist and scientific software developer working across QM/MM, nanoplasmonics, Python, C++, and Fortran.",
      now: Content.now(),
      projects: Content.list("projects") |> Enum.take(2),
      notes: Content.list("notes") |> Enum.take(3),
      pubs: Content.list("publications") |> Enum.take(2)
    ]

    {:ok, assign(socket, assigns)}
  end

  defp publication_label(%{venue: venue, date: %Date{} = date}) do
    "#{venue} · #{date.year}"
  end

  defp publication_label(%{venue: venue}), do: venue

  def render(assigns) do
    ~H"""
    <div>
      <%!-- HERO --%>
      <section class="pgi-hero" id="home-hero">
        <canvas id="hero-canvas" phx-hook="HeroCanvas" phx-update="ignore"></canvas>
        <div class="pgi-hero-fade"></div>
        <div class="pgi-hero-inner">
          <p class="pgi-hero-eyebrow">Computational Chemist &amp; Scientific Software Developer</p>
          <h1>Pablo<br />Grobas<br />Illobre, <em>PhD</em></h1>
          <p class="pgi-hero-desc">
            I develop computational tools for molecular and materials problems —
            connecting quantum-chemistry models with performant code and data-driven workflows.
          </p>
          <div class="pgi-hero-actions">
            <a href={~p"/cv"} class="pgi-btn pgi-btn-primary">View CV</a>
            <a href={~p"/software"} class="pgi-btn pgi-btn-ghost">Software</a>
            <a href="#contact" class="pgi-btn pgi-btn-ghost">Contact</a>
          </div>
        </div>
        <div class="pgi-hero-scroll">
          <span>Scroll</span>
          <div class="pgi-hero-scroll-line"></div>
        </div>
      </section>

      <%!-- SOFTWARE CARDS --%>
      <hr class="pgi-divider" />
      <div class="pgi-section reveal" id="home-proof">
        <div class="pgi-section-label">Software</div>
        <h2 class="pgi-section-title">Codes and tools.</h2>
        <div class="pgi-sw-grid">
          <%= for project <- @projects do %>
            <a href={~p"/software/#{project.slug}"} class="pgi-sw-card">
              <%= if project.image do %>
                <div class="pgi-sw-img-wrap">
                  <img src={project.image} alt={project.title} loading="lazy" />
                </div>
              <% end %>
              <div class="pgi-sw-body">
                <h3>{project.title}</h3>
                <p>{project.impact || project.summary}</p>
                <div class="pgi-sw-tags">
                  <%= for tag <- Enum.take(project.tags, 5) do %>
                    <span class="pgi-sw-tag">{tag}</span>
                  <% end %>
                </div>
              </div>
            </a>
          <% end %>
        </div>
        <a href={~p"/software"} class="pgi-browse-link">Browse all software &nbsp;↗</a>
      </div>

      <%!-- PUBLICATIONS --%>
      <hr class="pgi-divider" />
      <div class="pgi-section reveal" id="home-publications">
        <div class="pgi-section-label">Publications</div>
        <h2 class="pgi-section-title">Recent research output.</h2>
        <div class="pgi-pub-list">
          <%= for pub <- @pubs do %>
            <a
              href={pub.links["doi"]}
              class="pgi-pub-item"
              target="_blank"
              rel="noopener noreferrer"
            >
              <div>
                <div class="pgi-pub-journal">{publication_label(pub)}</div>
                <div class="pgi-pub-title">{pub.title}</div>
                <%= if pub.summary do %>
                  <div class="pgi-pub-abstract">{pub.summary}</div>
                <% end %>
              </div>
              <div class="pgi-pub-arrow">↗</div>
            </a>
          <% end %>
        </div>
      </div>

      <%!-- CTA BAND --%>
      <div class="pgi-cta-band" id="contact">
        <div class="pgi-cta-inner reveal">
          <p class="pgi-cta-text">
            Interested in molecular science, numerical methods, and tools with a<br />
            <em>life beyond one project.</em>
          </p>
          <div style="display:flex;gap:0.75rem;flex-wrap:wrap;">
            <a href={~p"/cv"} class="pgi-btn pgi-btn-primary">Read CV</a>
            <a href="https://www.linkedin.com/in/grobas-illobre/" target="_blank" rel="noopener noreferrer" class="pgi-btn pgi-btn-ghost">Get in touch</a>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
