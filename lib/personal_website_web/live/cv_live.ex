defmodule PersonalWebsiteWeb.CVLive do
  use PersonalWebsiteWeb, :live_view
  alias PersonalWebsite.Content

  @impl true
  def mount(_params, _session, socket) do
    section = "postdoc"

    pubs =
      Content.list("publications")
      # newest first
      |> Enum.sort_by(&pub_key/1, &>=/2)
      # keep the two most recent
      |> Enum.take(2)
      # display oldest→newest in the section
      |> Enum.sort_by(&pub_key/1, &<=/2)

    socket =
      socket
      |> assign(
        page_title: "CV — Pablo Grobas Illobre",
        meta_description: "Interactive CV and downloadable PDF for Pablo Grobas Illobre.",
        selected_section: section,
        recent_pubs: pubs,
        active_pub: nil
      )
      |> push_event("edu:markers", %{
        markers: markers_for(section),
        view: view_for(section)
      })

    {:ok, socket}
  end

  # Turn a publication into a sortable key {year, month, day}
  # Works with %Date{} or maps like %{year: 2024, month: 5, day: 1}
  defp pub_key(%{date: %Date{year: y, month: m, day: d}}), do: {y, m, d}

  defp pub_key(%{date: %{} = m}) do
    y = Map.get(m, :year)

    mth =
      case Map.get(m, :month) do
        n when is_integer(n) -> n
        _ -> 12
      end

    day =
      case Map.get(m, :day) do
        n when is_integer(n) -> n
        _ -> 31
      end

    if is_integer(y), do: {y, mth, day}, else: {0, 0, 0}
  end

  defp pub_key(_), do: {0, 0, 0}

  @impl true
  def handle_event("select_section", %{"section" => section}, socket) do
    {:noreply,
     socket
     |> assign(selected_section: section)
     |> push_event("edu:markers", %{
       markers: markers_for(section),
       view: view_for(section)
     })}
  end

  # Modal: open/close abstract (limit search to the two shown pubs)
  @impl true
  def handle_event("open_abstract", %{"slug" => slug}, socket) do
    pub = Enum.find(socket.assigns.recent_pubs, &(&1.slug == slug))
    {:noreply, assign(socket, active_pub: pub)}
  end

  @impl true
  def handle_event("close_abstract", _params, socket) do
    {:noreply, assign(socket, active_pub: nil)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="pgi-section">

      <%!-- Profile header --%>
      <div class="pgi-cv-header">
        <div class="pgi-cv-photo">
          <img src="/images/profile.jpg" alt="Pablo Grobas Illobre" />
        </div>
        <div class="pgi-cv-bio">
          <h1 style="font-family:var(--serif);font-size:clamp(1.4rem,4vw,2.6rem);font-weight:400;color:var(--text);margin-bottom:1rem;">
            Pablo Grobas Illobre, <em style="font-style:italic;color:transparent;-webkit-text-stroke:1px rgba(79,199,232,0.45);">PhD</em>
          </h1>
          <a href="https://www.linkedin.com/in/grobas-illobre/" target="_blank" rel="noopener noreferrer" class="pgi-btn pgi-btn-primary">Get in touch</a>
        </div>
      </div>
      <p class="pgi-cv-prose" style="text-align:justify;margin-bottom:1.5rem;">
        <strong>Computational chemist</strong> and <strong>scientific software developer</strong>
        with over <strong>six years of experience</strong> in
        <strong>quantum chemistry, QM/MM methodologies, and high-performance computing</strong>.
        Lead developer of <strong>quantum-chemistry algorithms (C++/Fortran)</strong>
        within the <strong>Amsterdam Modeling Suite</strong>, in collaboration with
        <strong>Software for Chemistry &amp; Materials (SCM)</strong>.
        Skilled in <strong>Python</strong> for
        <strong>data analysis, cheminformatics (RDKit)</strong>, and
        <strong>machine learning (TensorFlow, PyTorch)</strong>.
      </p>

      <%!-- Technical Skills --%>
      <h2 class="pgi-cv-h2">Technical Skills</h2>
      <ul class="pgi-cv-skills-grid">
        <li><strong>Expertise:</strong> QM/MM and molecular modelling</li>
        <li><strong>Programming:</strong> Python, C++, Fortran</li>
        <li><strong>Libraries:</strong> RDKit, TensorFlow, PyTorch, scikit-learn, NumPy, SciPy</li>
        <li><strong>Development:</strong> Git, VS Code, CI/CD basics</li>
        <li><strong>Systems:</strong> Linux, Bash, HPC environments</li>
        <li><strong>Scientific Software:</strong> Amsterdam Modeling Suite, Gaussian</li>
      </ul>

      <hr class="pgi-divider" style="margin:2.5rem 0;" />

      <%!-- Experience & Training --%>
      <h2 class="pgi-cv-h2" style="margin-top:0;">Experience &amp; Training</h2>
      <div style="display:flex;flex-wrap:wrap;gap:0.5rem;margin-bottom:2rem;">
        <%= for {label, sect} <- [
              {"Postdoc","postdoc"},
              {"Ph.D.","phd"},
              {"M.Sc.","msc"},
              {"Research Assistant","research"},
              {"B.Sc.","bsc"}
            ] do %>
          <button
            type="button"
            phx-click="select_section"
            phx-value-section={sect}
            aria-pressed={@selected_section == sect}
            class={["pgi-tag-btn", @selected_section == sect && "active"]}
          >{label}</button>
        <% end %>
      </div>

      <div class="pgi-cv-edu-grid">
        <div class="pgi-cv-map-wrap">
          <div id="cv-edu-map" phx-hook="EduMap" phx-update="ignore" style="width:100%;height:100%;"></div>
        </div>

        <div>
          <%= if @selected_section == "postdoc" do %>
            <h3 class="pgi-cv-h3">Senior Postdoctoral Researcher</h3>
            <p class="pgi-cv-label">Scuola Normale Superiore (Pisa, Italy)</p>
            <p class="pgi-cv-label" style="margin-bottom:1rem;">02/2025 – Present</p>
            <p class="pgi-cv-prose" style="text-align:justify;margin-bottom:0.75rem;">
              I lead the development of <strong>QM/MM quantum-chemistry algorithms</strong>
              in <strong>C++</strong> and <strong>Fortran</strong>
              within the <strong>Amsterdam Modeling Suite</strong>, in collaboration with
              <em>Software for Chemistry &amp; Materials</em>.
              This work is complemented with <strong>Python</strong>
              for <strong>machine learning</strong>, <strong>data analysis</strong>, and
              <strong>scientific visualization</strong> in spectroscopy and multiscale modelling research.
            </p>
            <p class="pgi-cv-prose" style="margin-bottom:0.5rem;">
              My research integrates intensive <strong>software development</strong> to investigate:
            </p>
            <ul class="pgi-cv-list">
              <li><strong>QM/MM Surface-Enhanced Spectroscopies</strong>: fluorescence, Raman scattering, Raman optical activity.</li>
              <li><strong>Plasmonic Materials</strong>: graphene &amp; metal nanoparticles.</li>
              <li><strong>Plasmon-Mediated Electronic Energy Transfer</strong>.</li>
            </ul>
            <div class="pgi-cv-lang-row">
              <span class="pgi-cv-lang-label">Working languages</span>
              <span>English · Italian</span>
            </div>
          <% end %>

          <%= if @selected_section == "phd" do %>
            <h3 class="pgi-cv-h3">
              Ph.D. in Methods and Models for Molecular Sciences (<em style="color:var(--accent);font-style:italic;">with honors</em>)
            </h3>
            <p class="pgi-cv-label">Scuola Normale Superiore (Pisa, Italy)</p>
            <p class="pgi-cv-label" style="margin-bottom:1rem;">11/2020 – 01/2025</p>
            <p class="pgi-cv-prose" style="text-align:justify;margin-bottom:0.75rem;">
              My PhD research focused on developing <strong>hybrid QM/MM methodologies</strong>
              for <strong>nanoplasmonic systems</strong> and <strong>light–matter interactions</strong>.
              I implemented simulation codes in <strong>Fortran</strong>, <strong>C++</strong>, and
              <strong>Python</strong> to model <strong>spectroscopic phenomena</strong>
              at the nanoscale, in collaboration with
              <em>Software for Chemistry &amp; Materials</em>
              — a partnership I continue in my current postdoctoral work.
            </p>
            <ul class="pgi-cv-list" style="margin-bottom:1rem;">
              <li>
                <strong>Title:</strong>
                <em>Modeling Atomistic Nanoplasmonics: Classical and Hybrid Quantum Mechanical/Classical Schemes</em>
              </li>
              <li><strong>Supervisors:</strong> Prof. Chiara Cappelli, Dr. Tommaso Giovannini</li>
            </ul>
            <a href="/pdfs/PhD_Thesis_Pablo_Grobas_Illobre.pdf" download class="pgi-btn pgi-btn-ghost" style="font-size:0.68rem;">
              ↓ Download PhD Thesis
            </a>
            <div class="pgi-cv-lang-row">
              <span class="pgi-cv-lang-label">Working languages</span>
              <span>English · Italian</span>
            </div>
          <% end %>

          <%= if @selected_section == "msc" do %>
            <h3 class="pgi-cv-h3">M.Sc. in Theoretical Chemistry and Computational Modeling (Erasmus Mundus)</h3>
            <p class="pgi-cv-label">Université Paul Sabatier (Toulouse, France)</p>
            <p class="pgi-cv-label" style="margin-bottom:1rem;">09/2018 – 08/2020</p>
            <p class="pgi-cv-prose" style="text-align:justify;margin-bottom:0.75rem;">
              The Erasmus Mundus TCCM program provided rigorous training in
              <strong>quantum chemistry</strong> as well as <strong>molecular dynamics</strong>,
              through an intensive hands-on, project-based curriculum. My M.Sc. thesis focused on
              <strong>high-performance Fortran development</strong> for quantum simulations, laying
              the foundation for later work in <strong>scientific programming</strong> and
              <strong>QM/MM methods</strong>.
            </p>
            <ul class="pgi-cv-list">
              <li>
                Thesis at University of Trieste (<strong>Fortran development</strong>).
                <strong>Supervisors:</strong> <em>Prof. Mauro Stener</em>, <em>Dr. Emanuele Coccia</em>
              </li>
              <li>Internship at Okayama University (<strong>MD simulations</strong> – Gromacs).</li>
              <li>Visiting student at Autonomous University of Madrid (<strong>Computational chemistry</strong>).</li>
            </ul>
            <div class="pgi-cv-lang-row">
              <span class="pgi-cv-lang-label">Working languages</span>
              <span>English · French · Spanish · Italian</span>
            </div>
          <% end %>

          <%= if @selected_section == "bsc" do %>
            <h3 class="pgi-cv-h3">B.Sc. in Chemistry</h3>
            <p class="pgi-cv-label">University of A Coruña (A Coruña, Spain)</p>
            <p class="pgi-cv-label" style="margin-bottom:1rem;">09/2014 – 07/2018</p>
            <p class="pgi-cv-prose" style="text-align:justify;margin-bottom:0.75rem;">
              My undergraduate degree offered a thorough grounding in
              <strong>organic</strong>, <strong>inorganic</strong>, <strong>analytical</strong>, and
              <strong>physical chemistry</strong>, complemented by extensive laboratory work in
              <strong>experimental techniques</strong> and <strong>instrumental analysis</strong>.
              In my final year, I carried out a theoretical project focused on modeling acid–base
              systems using <strong>DFT methods</strong> implemented in <strong>Gaussian</strong>,
              which first introduced me to <strong>computational chemistry</strong>.
            </p>
            <ul class="pgi-cv-list">
              <li>Erasmus Exchange: University of Oslo (2016).</li>
            </ul>
            <div class="pgi-cv-lang-row">
              <span class="pgi-cv-lang-label">Working languages</span>
              <span>English · Spanish · Galician</span>
            </div>
          <% end %>

          <%= if @selected_section == "research" do %>
            <h3 class="pgi-cv-h3">Research Assistant</h3>
            <p class="pgi-cv-label">Instituto de Tecnología Química (Valencia, Spain)</p>
            <p class="pgi-cv-label" style="margin-bottom:1rem;">07/2019 – 08/2019</p>
            <p class="pgi-cv-prose" style="text-align:justify;margin-bottom:0.75rem;">
              During my stay at the Instituto de Tecnología Química, I conducted
              <strong>molecular dynamics simulations</strong> with <strong>DL_POLY</strong>
              to study the adsorption of industrially relevant sugars into
              <strong>zeolitic frameworks</strong>, aiming to explore novel cost-effective
              separation strategies for the food industry.
            </p>
            <ul class="pgi-cv-list" style="margin-bottom:1rem;">
              <li><strong>Supervisor:</strong> <em>Dr. Germán Ignacio Sastre Navarro</em></li>
            </ul>
            <a
              href="https://linkinghub.elsevier.com/retrieve/pii/S1387181121001578"
              target="_blank"
              rel="noopener noreferrer"
              class="pgi-btn pgi-btn-ghost"
              style="font-size:0.68rem;"
            >
              View Related Publication ↗
            </a>
            <div class="pgi-cv-lang-row">
              <span class="pgi-cv-lang-label">Working languages</span>
              <span>English · Spanish</span>
            </div>
          <% end %>
        </div>
      </div>

      <hr class="pgi-divider" style="margin:2.5rem 0;" />

      <%!-- Research Projects --%>
      <h2 class="pgi-cv-h2" style="margin-top:0;">Research Projects</h2>

      <div class="pgi-cv-project-grid">
        <a href="https://www.scm.com/" target="_blank" rel="noopener noreferrer" class="pgi-cv-img-card" aria-label="SCM">
          <img src="/images/cv/scm.png" alt="SCM logo" />
        </a>
        <div>
          <h3 class="pgi-cv-h3">
            <a href="https://www.scm.com/" target="_blank" rel="noopener noreferrer" class="pgi-cv-inline-link">
              Quantum Chemistry Software for SCM (Software for Chemistry &amp; Materials)
            </a>
          </h3>
          <p class="pgi-cv-label" style="margin-bottom:0.75rem;">Industry collaboration · Scuola Normale Superiore | 2020 – Present</p>
          <ul class="pgi-cv-list">
            <li>Algorithms for <strong>Surface-Enhanced Raman Scattering (SERS)</strong>.</li>
            <li>Pipeline for <strong>Surface-Enhanced Fluorescence (SEF)</strong>.</li>
            <li>Tools for <strong>plasmon-mediated resonance energy transfer</strong>.</li>
            <li>Implementation of <strong>Surface-Enhanced Raman Optical Activity (SEROA)</strong> calculations.</li>
          </ul>
        </div>
      </div>

      <div class="pgi-cv-project-grid">
        <a href="/software/plasmonx" class="pgi-cv-img-card" aria-label="plasmonX">
          <img src="/images/cv/plasmonX.png" alt="plasmonX logo" />
        </a>
        <div>
          <h3 class="pgi-cv-h3">
            <a href="/software/plasmonx" class="pgi-cv-inline-link">
              High Performance Software for Nanoplasmonics Research
            </a>
          </h3>
          <p class="pgi-cv-label" style="margin-bottom:0.75rem;">Scuola Normale Superiore | 2020 – Present</p>
          <ul class="pgi-cv-list">
            <li>Standalone, <strong>parallelized</strong> implementations for <strong>&omega;FQF&mu;</strong> and <strong>BEM</strong> equations.</li>
            <li><strong>High-performance</strong> algorithms for solving linear systems via direct inversion and iterative schemes.</li>
            <li><strong>Analysis</strong> of the optical response (absorption spectra, charge/density distributions, and more).</li>
            <li>User-friendly interface via integration with the <strong>GEOM</strong> module.</li>
          </ul>
        </div>
      </div>

      <div class="pgi-cv-project-grid">
        <div class="pgi-cv-img-card">
          <img src="/images/cv/fare.png" alt="FARE logo" />
        </div>
        <div>
          <h3 class="pgi-cv-h3"><span style="color:var(--accent);">FARE — "Framework per l'attrazione e il rafforzamento delle eccellenze per la ricerca in Italia"</span></h3>
          <p class="pgi-cv-label" style="margin-bottom:0.75rem;">Scuola Normale Superiore | 2020 – Present | PI: Chiara Cappelli</p>
          <ul class="pgi-cv-list">
            <li>
              <strong>Python</strong> programming (in-house codes) for <strong>data analysis</strong>, <strong>manipulation</strong>, and <strong>visualization</strong>
              (e.g., Python-driven figures in
              <a href="https://pubs.rsc.org/en/content/articlelanding/2024/na/d4na00080c" target="_blank" class="pgi-cv-inline-link">
                P. Grobas Illobre <em>et al.</em>, <em>Nanoscale Adv.</em>, 2024, 6, 3410
              </a>).
            </li>
            <li>Quantum chemistry <strong>QM/MM software development</strong> in <strong>C++</strong> and <strong>Fortran</strong> for surface-enhanced fluorescence and plasmon-mediated electronic energy transfer.</li>
            <li>Intensive use of <strong>HPC</strong> infrastructures to automate and streamline <strong>data production</strong> workflows.</li>
          </ul>
        </div>
      </div>

      <div class="pgi-cv-project-grid">
        <a href="https://gems.sns.it/" target="_blank" rel="noopener noreferrer" class="pgi-cv-img-card" aria-label="GEMS">
          <img src="/images/cv/gems.png" alt="GEMS logo" />
        </a>
        <div>
          <h3 class="pgi-cv-h3">
            <a href="https://gems.sns.it/" target="_blank" rel="noopener noreferrer" class="pgi-cv-inline-link">
              GEMS — General Embedding Models for Spectroscopy
            </a>, ERC Consolidator Grant
          </h3>
          <p class="pgi-cv-label" style="margin-bottom:0.75rem;">Scuola Normale Superiore | 2020 – 2025 | PI: Chiara Cappelli</p>
          <ul class="pgi-cv-list">
            <li>
              <strong>Python</strong> programming for <strong>data analysis</strong>, <strong>manipulation</strong>, and <strong>visualization</strong>
              (e.g., Python-driven figures in
              <a href="https://pubs.acs.org/doi/10.1021/acsphotonics.2c00761" target="_blank" class="pgi-cv-inline-link">
                T. Giovannini <em>et al.</em>, <em>ACS Photonics</em>, 2022, 9, 3025
              </a>).
            </li>
            <li>Machine learning pipeline in <strong>Python</strong> to study and simulate graphene samples.</li>
            <li>Quantum chemistry <strong>software development</strong> in <strong>Fortran</strong> for plasmonic materials, <strong>QM/MM</strong> SERS, and Raman optical activity.</li>
            <li>Intensive use of <strong>HPC</strong> infrastructures for large-scale <strong>data production</strong> workflows.</li>
          </ul>
        </div>
      </div>

      <a href={~p"/software"} class="pgi-cv-footer-link">See related software →</a>

      <hr class="pgi-divider" style="margin:2.5rem 0;" />

      <%!-- Selected Publications --%>
      <h2 class="pgi-cv-h2" style="margin-top:0;">Selected Publications</h2>

      <div>
        <%= for p <- @recent_pubs do %>
          <div class="pgi-cv-pub-item">
            <%= if p.image do %>
              <button
                type="button"
                phx-click="open_abstract"
                phx-value-slug={p.slug}
                class="pgi-cv-pub-toc"
              >
                <img src={p.image} alt={"TOC graphic for " <> p.title} loading="lazy" />
              </button>
            <% end %>
            <div style="flex:1;min-width:0;">
              <%= if p.venue do %>
                <div class="pgi-pub-journal">{p.venue}{if p.date, do: " · #{p.date.year}"}</div>
              <% end %>
              <button
                type="button"
                phx-click="open_abstract"
                phx-value-slug={p.slug}
                class="pgi-cv-pub-title"
              >
                {p.title}
              </button>
              <%= if (p.authors || []) != [] do %>
                <div class="pgi-pub-authors" style="margin-top:0.4rem;">
                  <%= for {a, i} <- Enum.with_index(p.authors) do %>
                    {if i > 0, do: ", "}
                    <span class={if a == "P. Grobas Illobre", do: "self", else: ""}>{a}</span>
                  <% end %>
                </div>
              <% end %>
              <%= if p.summary do %>
                <p class="pgi-pub-abstract" style="margin-top:0.5rem;">{p.summary}</p>
              <% end %>
              <%= if p.links && p.links["doi"] do %>
                <a
                  href={p.links["doi"]}
                  target="_blank"
                  rel="noopener noreferrer"
                  class="pgi-cv-footer-link"
                  style="margin-top:0.75rem;font-size:0.65rem;"
                >
                  Read the article →
                </a>
              <% end %>
            </div>
          </div>
        <% end %>
      </div>

      <a href={~p"/publications"} class="pgi-cv-footer-link">See all publications →</a>

      <%!-- Abstract modal --%>
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
              <button phx-click="close_abstract" type="button" class="pgi-modal-close">Close</button>
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
              <div style="font-family:var(--serif);font-size:clamp(1rem,2.2vw,1.15rem);font-weight:400;line-height:1.3;color:var(--text);margin-bottom:0.8rem;">
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
                <p class="pgi-pub-abstract" style="font-size:0.85rem;line-height:1.7;">{@active_pub.abstract}</p>
              <% else %>
                <%= if @active_pub.summary do %>
                  <p class="pgi-pub-abstract" style="font-size:0.85rem;line-height:1.7;">{@active_pub.summary}</p>
                <% end %>
              <% end %>
              <%= if @active_pub.links && @active_pub.links["doi"] do %>
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

      <hr class="pgi-divider" style="margin:2.5rem 0;" />

      <%!-- Awards --%>
      <h2 class="pgi-cv-h2" style="margin-top:0;">Awards</h2>
      <ul class="pgi-cv-list">
        <li>PhD awarded with honors (<em>with honors</em>).</li>
        <li>Scuola Normale Superiore PhD Scholarship (2020–2025).</li>
        <li>Two NanoX Research Scholarships (2019 &amp; 2020).</li>
        <li>Erasmus Internship Fellowship (2019–2020).</li>
        <li>Consejo Superior de Investigaciones Científicas (CSIC) – Jae Intro Fellowship (2019).</li>
        <li>Extraordinary Prize for achieving the best academic record in the Bachelor of Chemistry (2018).</li>
        <li>Erasmus+ scholarship (2016).</li>
      </ul>

    </div>
    """
  end

  # -------------------------
  # Marker data per section
  # -------------------------
  defp markers_for("postdoc"),
    do: [
      %{lat: 43.716, lng: 10.403, label: "Pisa · SNS", offset: %{dlat: 0.7, dlng: 1.0}}
    ]

  defp markers_for("phd"),
    do: [
      %{lat: 43.716, lng: 10.403, label: "Pisa · SNS", offset: %{dlat: 0.7, dlng: 1.0}}
    ]

  defp markers_for("msc"),
    do: [
      %{lat: 43.6045, lng: 1.4440, label: "Toulouse · UPS", offset: %{dlat: 0.6, dlng: 0.9}},
      %{lat: 45.6495, lng: 13.7768, label: "Trieste · UniTS", offset: %{dlat: 0.6, dlng: -0.9}},
      %{lat: 40.4168, lng: -3.7038, label: "Madrid · UAM", offset: %{dlat: -0.6, dlng: -0.9}},
      %{
        lat: 34.6550,
        lng: 133.9190,
        label: "Okayama · Okayama University",
        offset: %{dlat: 0.6, dlng: 0.9}
      }
    ]

  defp markers_for("bsc"),
    do: [
      %{lat: 43.3623, lng: -8.4115, label: "A Coruña · UDC", offset: %{dlat: 0.6, dlng: 0.9}},
      %{lat: 59.9139, lng: 10.7522, label: "Oslo · UiO", offset: %{dlat: -0.6, dlng: 0.9}}
    ]

  defp markers_for("research"),
    do: [
      %{lat: 39.4699, lng: -0.3763, label: "Valencia · ITQ", offset: %{dlat: 0.6, dlng: 0.9}}
    ]

  defp markers_for(_), do: []

  # -------------------------
  # View per section (country-level)
  # -------------------------
  # Italy
  defp view_for("postdoc"), do: %{center: [42.5, 12.5], zoom: 5}
  # Italy
  defp view_for("phd"), do: %{center: [42.5, 12.5], zoom: 5}
  # Spain (mainland)
  defp view_for("research"), do: %{center: [40.2, -3.5], zoom: 5}
  defp view_for(_), do: nil
end
