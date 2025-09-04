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

    <!-- Radial background placed at the very back -->
    <div aria-hidden="true"
        class="pointer-events-none absolute inset-0 -z-30
                bg-[radial-gradient(1400px_700px_at_50%_-10%,#e0f2fe_0%,transparent_72%)]">
    </div>

    <!-- Video layer, masked + tiny bottom overhang to avoid 1px seam -->
    <div id="hero-video"
        phx-hook="HeroVideo"
        class="absolute inset-x-0 top-0 h-[clamp(560px,80svh,900px)] -z-20 hero-video-mask opacity-5">
      <!-- Underlay still (hidden initially) -->
      <img
        id="hero-still"
        src={~p"/videos/molecules-final.jpg"}
        alt=""
        class="absolute inset-0 w-full h-full object-cover object-[50%_40%] select-none pointer-events-none opacity-0 transition-opacity duration-500"
        loading="eager"
        decoding="async"
      />

      <!-- Video on top (visible initially) -->
      <video
        id="hero-video-el"
        class="absolute inset-0 w-full h-full object-cover object-[50%_40%] transition-opacity duration-500 opacity-100"
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


      <!-- hero -->
      <div class="max-w-6xl mx-auto px-6 py-9 text-center space-y-7">
        <!-- photo with subtle gradient ring -->
        <div class="mx-auto h-60 w-60 md:h-70 md:w-70 lg:h-80 lg:w-80 rounded-full p-[5px]  <!-- Increased sizes -->
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
          <p class="mt-5 text-xl text-gray-800">
            Computational Chemist & Scientific Software Developer (Python · C++ · Fortran)
          </p>
        </div>

        <!-- CTAs -->
        <div class="flex flex-wrap justify-center gap-3">
          <!--  <a href={~p"/about"} class="px-5 py-2.5 rounded-2xl bg-gray-900 text-white shadow hover:opacity-95">
            About
          </a> -->
          <a href="/cv.pdf" class="text-xl px-5 py-2.5 rounded-2xl bg-white shadow ring-1 ring-gray-200 hover:bg-gradient-to-br hover:from-sky-50 hover:to-indigo-50
                       hover:shadow-md hover:border-sky-300 transition
                       flex gap-4 p-4">
            CV
          </a>
          <a href={~p"/software"} class="text-xl px-5 py-2.5 rounded-2xl bg-white shadow ring-1 ring-gray-200 hover:bg-gradient-to-br hover:from-sky-50 hover:to-indigo-50
                       hover:shadow-md hover:border-sky-300 transition
                       flex gap-4 p-4">
            Software
          </a>

          <a href={~p"/publications"} class="text-xl px-5 py-2.5 rounded-2xl bg-white shadow ring-1 ring-gray-200 hover:bg-gradient-to-br hover:from-sky-50 hover:to-indigo-50
                       hover:shadow-md hover:border-sky-300 transition
                       flex gap-4 p-4">
            Publications
          </a>

          <!-- new contact trigger (same dropdown as navbar) -->
          <button
            type="button"
            data-contact-trigger
            aria-haspopup="true"
            aria-expanded="false"
            class="text-xl px-5 py-2.5 rounded-2xl bg-white shadow ring-1 ring-gray-200 hover:bg-gradient-to-br hover:from-sky-50 hover:to-indigo-50
                       hover:shadow-md hover:border-sky-300 transition
                       flex gap-4 p-4"
          >
            Contact
          </button>
        </div>
      </div>

      <!-- Short personal blurb inside the hero -->
      <div class="mx-auto max-w-3xl text-left md:text-center text-gray-800 leading-relaxed">
        <p class="text-xl">
          Hey there 👋 I’m a computational chemist and scientific software developer with 6+ years of experience,
          specializing in quantum chemistry and high-performance scientific programming. I build tools
          for QM/MM applications in C++, Fortran and Python.
        </p>
        <p class="mt-5 text-xl">
          Currently, I’m a postdoctoral researcher at the Scuola Normale Superiore (Pisa, Italy), where I also
          completed my Ph.D. <em>cum laude</em> in Methods and Models for Molecular Sciences. My research combines software development, quantum chemistry, and machine learning  to investigate molecular systems.
        </p>
        <p class="mt-5 text-xl">
          <a href={~p"/about"} class="underline">More about me →</a>
        </p>
      </div>
    </section>
    """
  end
end
