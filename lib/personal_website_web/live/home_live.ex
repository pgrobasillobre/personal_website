defmodule PersonalWebsiteWeb.HomeLive do
  use PersonalWebsiteWeb, :live_view
  alias PersonalWebsite.Content

  def mount(_params, _session, socket) do
    assigns = [
      page_title: "Pablo Grobas Illobre - Computational Chemist & Scientific Software Developer",
      meta_description:
        "Computational chemist and scientific software developer working across QM/MM, nanoplasmonics, Python, C++, and Fortran.",
      now: Content.now(),
      projects: Content.list("projects") |> Enum.take(3),
      notes: Content.list("notes") |> Enum.take(3),
      pubs: Content.list("publications") |> Enum.take(3)
    ]

    {:ok, assign(socket, assigns)}
  end

  defp publication_label(%{venue: venue, date: %Date{} = date}) do
    "#{venue} (#{date.year})"
  end

  defp publication_label(%{venue: venue}), do: venue

  def render(assigns) do
    ~H"""
    <div class="relative isolate overflow-hidden bg-[#faf9f5] text-slate-950">
      <div
        aria-hidden="true"
        class="pointer-events-none absolute inset-x-0 top-0 -z-20 h-[760px] bg-[linear-gradient(180deg,#ffffff_0%,rgba(250,249,245,0.72)_46%,rgba(250,249,245,0)_100%)]"
      >
      </div>

      <div
        id="hero-video"
        phx-hook="HeroVideo"
        phx-update="ignore"
        class="absolute inset-x-0 top-0 -z-10 h-[clamp(620px,88svh,920px)] w-full hero-video-mask bg-[#faf9f5] opacity-14"
      >
        <img
          id="hero-still"
          src={~p"/videos/molecules-final.jpg"}
          alt=""
          class="absolute inset-0 h-full w-full select-none object-cover object-[50%_38%] opacity-0 transition-opacity duration-500"
          loading="eager"
          decoding="async"
        />
        <video
          id="hero-video-el"
          class="absolute inset-0 h-full w-full object-cover object-[50%_38%] opacity-100 brightness-125 contrast-110 saturate-90 transition-opacity duration-500"
          autoplay
          muted
          playsinline
          preload="auto"
          poster={~p"/videos/molecules-final.jpg"}
          aria-hidden="true"
        >
          <source src={~p"/videos/molecules.mp4"} type="video/mp4" />
        </video>
      </div>
      <div
        aria-hidden="true"
        class="pointer-events-none absolute inset-x-0 top-0 -z-10 h-[clamp(620px,88svh,920px)] bg-[linear-gradient(90deg,rgba(250,249,245,0.98)_0%,rgba(250,249,245,0.92)_42%,rgba(250,249,245,0.72)_70%,rgba(250,249,245,0.46)_100%)]"
      >
      </div>

      <section
        id="home-hero"
        class="relative mx-auto grid min-h-[calc(100svh-3.5rem)] max-w-7xl content-center items-center gap-8 px-5 py-14 sm:px-6 lg:grid-cols-[minmax(0,1.28fr)_360px] lg:px-8"
      >
        <div>
          <h1 class="max-w-none text-5xl font-semibold leading-[0.98] tracking-tight text-slate-950 sm:text-6xl lg:whitespace-nowrap lg:text-6xl">
            Pablo Grobas Illobre, PhD
          </h1>
          <p class="mt-5 font-mono text-sm font-semibold uppercase tracking-[0.18em] text-slate-500">
            Computational chemistry · scientific software · AI for science
          </p>
          <p class="mt-7 max-w-3xl text-xl leading-8 text-slate-700 sm:text-2xl sm:leading-9">
            I develop computational tools for molecular and materials problems, connecting
            quantum-chemistry models with performant code and data-driven workflows.
          </p>

          <div class="mt-9 flex flex-wrap gap-3" aria-label="Primary actions">
            <a
              id="home-hero-cv"
              href={~p"/cv"}
              class="inline-flex items-center rounded-md bg-slate-950 px-5 py-3 text-base font-semibold text-white shadow-sm transition hover:bg-slate-800 focus:outline-none focus-visible:ring-2 focus-visible:ring-slate-500"
            >
              CV
            </a>
            <a
              id="home-hero-software"
              href={~p"/software"}
              class="inline-flex items-center rounded-md border border-slate-300 bg-white px-5 py-3 text-base font-semibold text-slate-950 shadow-sm transition hover:border-slate-500 focus:outline-none focus-visible:ring-2 focus-visible:ring-slate-500"
            >
              Software
            </a>
            <button
              id="home-hero-contact"
              type="button"
              data-contact-trigger
              aria-haspopup="true"
              aria-expanded="false"
              class="inline-flex items-center rounded-md border border-transparent px-5 py-3 text-base font-semibold text-slate-700 transition hover:bg-white focus:outline-none focus-visible:ring-2 focus-visible:ring-slate-500"
            >
              Contact
            </button>
          </div>

          <div class="mt-10 grid max-w-4xl gap-3 sm:grid-cols-3">
            <article class="border-l-4 border-slate-900 bg-white/80 p-4 shadow-sm backdrop-blur">
              <h2 class="font-mono text-xs font-semibold uppercase tracking-[0.16em] text-slate-500">
                Build
              </h2>
              <p class="mt-2 text-lg font-semibold text-slate-950">
                From methods to usable tools
              </p>
            </article>
            <article class="border-l-4 border-slate-400 bg-white/80 p-4 shadow-sm backdrop-blur">
              <h2 class="font-mono text-xs font-semibold uppercase tracking-[0.16em] text-slate-500">
                Simulate
              </h2>
              <p class="mt-2 text-lg font-semibold text-slate-950">
                Molecular systems and plasmonic materials
              </p>
            </article>
            <article class="border-l-4 border-slate-300 bg-white/80 p-4 shadow-sm backdrop-blur">
              <h2 class="font-mono text-xs font-semibold uppercase tracking-[0.16em] text-slate-500">
                Connect
              </h2>
              <p class="mt-2 text-lg font-semibold text-slate-950">
                Physics-based methods and AI workflows
              </p>
            </article>
          </div>
        </div>

        <aside class="flex flex-col rounded-xl border border-slate-200 bg-white p-5 shadow-xl shadow-slate-200/70 lg:self-stretch">
          <div class="flex items-start gap-4">
            <img
              src={~p"/images/profile.jpg"}
              alt="Pablo Grobas Illobre"
              class="h-28 w-28 shrink-0 rounded-lg object-cover ring-1 ring-slate-200"
            />
            <div>
              <p class="text-lg leading-7 text-slate-700">
                Postdoctoral researcher at Scuola Normale Superiore, Pisa.
              </p>
            </div>
          </div>

          <div class="mt-6 space-y-4">
            <div class="rounded-lg bg-slate-50 p-4">
              <h3 class="font-mono text-xs font-semibold uppercase tracking-[0.16em] text-slate-500">
                Current work
              </h3>
              <p class="mt-2 text-lg leading-7 text-slate-800">
                QM/MM multiscale method development and application for molecular systems, plasmonic materials, and spectroscopy. Applying physics-informed AI models to materials and molecular modeling.
              </p>
            </div>
            <div class="grid gap-3 text-sm leading-6 text-slate-700">
              <p>
                <span class="font-semibold text-slate-950">Stack:</span> Python, C++, Fortran.
              </p>
            </div>
          </div>
        </aside>

        <button
          id="home-scroll-cue"
          type="button"
          data-scroll-target="#home-positioning"
          phx-hook="HomeScrollCue"
          aria-label="Scroll to the next section"
          class="home-scroll-cue group absolute bottom-5 left-1/2 z-20 flex -translate-x-1/2 items-center justify-center rounded-full focus:outline-none focus-visible:ring-2 focus-visible:ring-slate-500 focus-visible:ring-offset-4 focus-visible:ring-offset-[#faf9f5]"
        >
          <span class="home-scroll-cue-mark flex size-14 items-center justify-center rounded-full border border-slate-400/80 bg-white/90 text-slate-700 shadow-xl shadow-slate-300/40 backdrop-blur transition group-hover:border-slate-600 group-hover:bg-white group-hover:text-slate-950 sm:size-16">
            <.icon name="hero-chevron-down" class="size-8 sm:size-9" />
          </span>
        </button>
      </section>

      <section id="home-positioning" class="border-y border-slate-200 bg-white">
        <div class="mx-auto max-w-7xl px-5 py-14 sm:px-6 lg:px-8">
          <div class="grid gap-10 lg:grid-cols-[360px_1fr]">
            <div>
              <p class="font-mono text-sm font-semibold uppercase tracking-[0.18em] text-slate-500">
                Direction
              </p>
              <h2 class="mt-3 text-3xl font-semibold tracking-tight text-slate-950 sm:text-4xl">
                Science, code, and molecular models.
              </h2>
              <p class="mt-4 text-lg leading-8 text-slate-600">
                My work moves between theory, implementation, and interpretation: building tools that make complex simulations easier to use and reason about.
              </p>
            </div>

            <div class="overflow-visible">
              <div class="grid gap-4 md:grid-cols-3">
                <article class="rounded-lg border border-slate-200 bg-slate-50 p-5">
                  <p class="font-mono text-xs font-semibold uppercase tracking-[0.16em] text-slate-500">
                    01
                  </p>
                  <h3 class="mt-3 text-xl font-semibold text-slate-950">Molecular science</h3>
                  <p class="mt-3 leading-7 text-slate-600">
                    A chemistry foundation for asking the right computational questions.
                  </p>
                </article>
                <article class="rounded-lg border border-slate-200 bg-slate-50 p-5">
                  <p class="font-mono text-xs font-semibold uppercase tracking-[0.16em] text-slate-500">
                    02
                  </p>
                  <h3 class="mt-3 text-xl font-semibold text-slate-950">Scientific code</h3>
                  <p class="mt-3 leading-7 text-slate-600">
                    Implementations that connect numerical methods, data, and real research workflows.
                  </p>
                </article>
                <article class="rounded-lg border border-slate-200 bg-slate-50 p-5">
                  <p class="font-mono text-xs font-semibold uppercase tracking-[0.16em] text-slate-500">
                    03
                  </p>
                  <h3 class="mt-3 text-xl font-semibold text-slate-950">Research output</h3>
                  <p class="mt-3 leading-7 text-slate-600">
                    Papers and project pages that show the scientific context behind the work.
                  </p>
                </article>
              </div>

              <div
                id="home-positioning-arrow"
                phx-hook="HomeTimeline"
                class="home-positioning-arrow mt-8 hidden overflow-visible md:block"
                aria-hidden="true"
              >
                <svg
                  viewBox="0 0 1000 48"
                  class="h-10 w-full overflow-visible"
                  role="img"
                >
                  <defs>
                    <marker
                      id="home-positioning-arrowhead"
                      viewBox="0 0 10 10"
                      refX="8"
                      refY="5"
                      markerWidth="7"
                      markerHeight="7"
                      orient="auto-start-reverse"
                    >
                      <path d="M 0 0 L 10 5 L 0 10 z" class="fill-slate-900" />
                    </marker>
                    <filter
                      id="home-positioning-arrow-glow"
                      x="-10%"
                      y="-80%"
                      width="120%"
                      height="260%"
                    >
                      <feGaussianBlur stdDeviation="3" result="blur" />
                      <feMerge>
                        <feMergeNode in="blur" />
                        <feMergeNode in="SourceGraphic" />
                      </feMerge>
                    </filter>
                  </defs>

                  <path
                    class="home-positioning-arrow-shadow"
                    d="M 166 16 C 234 16 340 16 500 16 S 742 16 834 16 S 1080 16 1460 16"
                    pathLength="1"
                  />
                  <path
                    class="home-positioning-arrow-line"
                    d="M 166 16 C 234 16 340 16 500 16 S 742 16 834 16 S 1080 16 1460 16"
                    pathLength="1"
                    marker-end="url(#home-positioning-arrowhead)"
                    filter="url(#home-positioning-arrow-glow)"
                  />

                  <g class="home-positioning-checkpoint home-positioning-checkpoint-1">
                    <circle cx="166" cy="16" r="13" />
                    <circle cx="166" cy="16" r="5" />
                  </g>
                  <g class="home-positioning-checkpoint home-positioning-checkpoint-2">
                    <circle cx="500" cy="16" r="13" />
                    <circle cx="500" cy="16" r="5" />
                  </g>
                  <g class="home-positioning-checkpoint home-positioning-checkpoint-3">
                    <circle cx="834" cy="16" r="13" />
                    <circle cx="834" cy="16" r="5" />
                  </g>
                </svg>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section id="home-proof" class="mx-auto max-w-7xl px-5 py-16 sm:px-6 lg:px-8">
        <div class="grid gap-10 lg:grid-cols-[0.85fr_1.15fr]">
          <div>
            <p class="font-mono text-sm font-semibold uppercase tracking-[0.18em] text-slate-500">
              Software
            </p>
            <h2 class="mt-3 text-4xl font-semibold tracking-tight text-slate-950">
              Codes and tools.
            </h2>
            <p class="mt-4 text-lg leading-8 text-slate-600">
              These projects show the kind of problems I work on: molecular geometries,
              energy transfer, solvent electrostatics, and nanoplasmonics.
            </p>
            <a
              id="home-all-software"
              href={~p"/software"}
              class="mt-6 inline-flex rounded-md border border-slate-300 bg-white px-4 py-2 text-sm font-semibold text-slate-950 transition hover:border-slate-500"
            >
              Browse all software
            </a>
          </div>

          <div class="grid gap-4">
            <%= for project <- @projects do %>
              <article class="grid gap-4 rounded-lg border border-slate-200 bg-white p-4 shadow-sm transition hover:border-slate-300 hover:shadow-md sm:grid-cols-[132px_1fr]">
                <%= if project.image do %>
                  <a href={~p"/software/#{project.slug}"} class="rounded-md bg-slate-50 p-3">
                    <img
                      src={project.image}
                      alt={"Screenshot of " <> project.title}
                      class="aspect-square w-full object-contain"
                      loading="lazy"
                    />
                  </a>
                <% end %>
                <div>
                  <h3 class="text-2xl font-semibold text-slate-950">
                    <a href={~p"/software/#{project.slug}"}>{project.title}</a>
                  </h3>
                  <p class="mt-2 text-base leading-7 text-slate-600">
                    {project.impact || project.summary}
                  </p>
                  <div class="mt-4 flex flex-wrap gap-2">
                    <%= for tag <- Enum.take(project.tags, 5) do %>
                      <span class="rounded border border-slate-200 bg-slate-50 px-2 py-1 font-mono text-xs text-slate-600">
                        {tag}
                      </span>
                    <% end %>
                  </div>
                </div>
              </article>
            <% end %>
          </div>
        </div>
      </section>

      <section id="home-publications" class="bg-slate-950 text-white">
        <div class="mx-auto max-w-7xl px-5 py-16 sm:px-6 lg:px-8">
          <div class="grid gap-10 lg:grid-cols-[360px_1fr]">
            <div>
              <p class="font-mono text-sm font-semibold uppercase tracking-[0.18em] text-slate-300">
                Publications
              </p>
              <h2 class="mt-3 text-3xl font-semibold tracking-tight sm:text-4xl">
                Recent research output.
              </h2>
            </div>
            <div class="grid gap-4">
              <%= for pub <- @pubs do %>
                <a
                  href={pub.links["doi"]}
                  class="group block rounded-lg border border-white/10 bg-white/[0.04] p-5 transition hover:border-white/25 hover:bg-white/[0.07] focus:outline-none focus-visible:ring-2 focus-visible:ring-white/50"
                  target="_blank"
                  rel="noopener noreferrer"
                >
                  <article>
                    <p class="font-mono text-xs font-semibold uppercase tracking-[0.16em] text-slate-300">
                      {publication_label(pub)}
                    </p>
                    <h3 class="mt-2 text-xl font-semibold leading-7">
                      {pub.title}
                    </h3>
                    <p class="mt-3 line-clamp-3 leading-7 text-slate-300">
                      {pub.summary}
                    </p>
                  </article>
                </a>
              <% end %>
            </div>
          </div>
        </div>
      </section>

      <section id="home-close" class="bg-white">
        <div class="mx-auto grid max-w-7xl gap-8 px-5 py-14 sm:px-6 lg:grid-cols-[1fr_auto] lg:items-center lg:px-8">
          <div>
            <p class="font-mono text-sm font-semibold uppercase tracking-[0.18em] text-slate-500">
              Connect
            </p>
            <h2 class="mt-3 max-w-4xl text-3xl font-semibold tracking-tight text-slate-950 sm:text-4xl">
              Interested in molecular science, numerical methods, and tools with a life beyond one project.
            </h2>
            <p class="mt-4 max-w-3xl text-lg leading-8 text-slate-600">
              Explore the projects and publications, or get in touch for collaborations.
            </p>
          </div>
          <div class="flex flex-wrap gap-3 lg:justify-end">
            <a
              id="home-close-cv"
              href={~p"/cv"}
              class="rounded-md bg-slate-950 px-5 py-3 text-base font-semibold text-white shadow-sm transition hover:bg-slate-800"
            >
              Read CV
            </a>
            <button
              id="home-close-contact"
              type="button"
              data-contact-trigger
              aria-haspopup="true"
              aria-expanded="false"
              class="rounded-md border border-slate-300 bg-white px-5 py-3 text-base font-semibold text-slate-950 transition hover:border-slate-500"
            >
              Get in touch
            </button>
          </div>
        </div>
      </section>
    </div>
    """
  end
end
