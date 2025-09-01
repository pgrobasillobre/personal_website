defmodule PersonalWebsiteWeb.HomeLive do
  use PersonalWebsiteWeb, :live_view
  alias PersonalWebsite.Content

  # assign(socket, [key1: val1, key2: val2]) is valid shorthand!
  def mount(_params, _session, socket) do
    assigns = [
      page_title: "Pablo Grobas Illobre — Computational Chemist & Scientific Software Developer",
      meta_description: "Projects, publications, and notes. Now: " <> Enum.join(PersonalWebsite.Content.now(), " "),
      now: PersonalWebsite.Content.now(),
      projects: PersonalWebsite.Content.list("projects") |> Enum.take(1),
      notes: PersonalWebsite.Content.list("notes") |> Enum.take(3),
      pubs: PersonalWebsite.Content.list("publications") |> Enum.take(2)
      ]
    {:ok, assign(socket, assigns)}
  end

  def render(assigns) do
    ~H"""
    <section class="relative isolate overflow-hidden">
      <!-- gradient background -->
      <div aria-hidden="true"
          class="pointer-events-none absolute inset-0 -z-10
                  bg-[radial-gradient(1400px_700px_at_50%_-10%,#e0f2fe_0%,transparent_72%)]">
      </div>

      <!-- hero -->
      <div class="max-w-3xl mx-auto px-6 py-20 text-center space-y-8">
        <!-- photo with subtle gradient ring -->
        <div class="mx-auto h-48 w-48 md:h-56 md:w-56 lg:h-64 lg:w-64 rounded-full p-[3px]
                    bg-gradient-to-br from-cyan-400 to-indigo-500 shadow-xl ring-1 ring-black/5">
          <img
            src="/images/profile.jpg"
            alt="Pablo Grobas Illobre"
            class="h-full w-full rounded-full object-cover"
          />
        </div>

        <div class="space-y-2">
          <h1 class="text-3xl md:text-4xl font-semibold tracking-tight">
            Pablo Grobas Illobre, PhD
          </h1>
          <p class="text-gray-700">
            Computational Chemist & Scientific Software Developer (Python · C++ · Fortran)
          </p>
        </div>

        <!-- CTAs -->
        <div class="flex flex-wrap justify-center gap-3">
          <!--  <a href={~p"/about"} class="px-5 py-2.5 rounded-2xl bg-gray-900 text-white shadow hover:opacity-95">
            About
          </a> -->
          <a href="/cv.pdf" class="px-5 py-2.5 rounded-2xl bg-white shadow ring-1 ring-gray-200 hover:bg-gray-50">
            CV
          </a>
          <a href={~p"/software"} class="px-5 py-2.5 rounded-2xl bg-white shadow ring-1 ring-gray-200 hover:bg-gray-50">
            Software
          </a>

          <a href={~p"/publications"} class="px-5 py-2.5 rounded-2xl bg-white shadow ring-1 ring-gray-200 hover:bg-gray-50">
            Publications
          </a>

          <!-- new contact trigger (same dropdown as navbar) -->
          <button
            type="button"
            data-contact-trigger
            aria-haspopup="true"
            aria-expanded="false"
            class="px-5 py-2.5 rounded-2xl bg-white shadow ring-1 ring-gray-200 hover:bg-gray-50"
          >
            Contact
          </button>
        </div>
      </div>

      <!-- Short personal blurb inside the hero -->
      <div class="mx-auto max-w-2xl text-left md:text-center text-gray-700 leading-relaxed">
        <p>
          I’m a computational chemist and scientific software developer with 6+ years of experience,
          specializing in quantum chemistry and high-performance scientific programming. I build tools
          to study light–matter interactions in QM/MM at the nanoscale.
        </p>
        <p class="mt-3">
          Currently I’m a postdoctoral researcher at the Scuola Normale Superiore (Pisa, Italy), where I also
          completed my Ph.D. <em>cum laude</em> in Methods and Models for Molecular Sciences. My work combines
          machine learning, software development, and QM/MM quantum chemistry to investigate molecular systems
          influenced by plasmonic materials.
        </p>
        <p class="mt-3">
          <a href={~p"/about"} class="underline">More about me →</a>
        </p>
      </div>
    </section>
    """
  end
end
