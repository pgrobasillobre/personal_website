defmodule PersonalWebsiteWeb.CVLive do
  use PersonalWebsiteWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket,
      page_title: "CV — Pablo Grobas Illobre",
      meta_description: "Interactive CV and downloadable PDF for Pablo Grobas Illobre."
    )}
  end

  @impl true
  def render(assigns) do
    ~H"""


    <!-- gradient background -->
    <div aria-hidden="true"
        class="pointer-events-none absolute inset-0 -z-10
                bg-[radial-gradient(1400px_700px_at_50%_-10%,#e0f2fe_0%,transparent_72%)]">
    </div>

    <section class="bg-white">

      <div class="max-w-7xl mx-auto p-6 space-y-6">
        <h1 class="text-5xl font-semibold mt-6 mb-6">Curriculum Vitae</h1>
      </div>

      <!-- Hero-style top layout -->
      <div class="max-w-7xl mx-auto px-4 py-5 grid grid-cols-1 md:grid-cols-3 gap-8 items-start">
        <!-- Left: photo -->
        <div class="mx-auto mt-15 h-60 w-60 md:h-70 md:w-70 lg:h-75 lg:w-75 rounded-full p-[5px]  <!-- Increased sizes -->
                    bg-gradient-to-br from-cyan-400 to-indigo-500 shadow-xl ring-1 ring-black/5">
          <img
            src="/images/profile.jpg"
            alt="Pablo Grobas Illobre"
            class="h-full w-full rounded-full object-cover"
          />
        </div>

        <!-- Right: summary, skills, buttons -->
        <div class="md:col-span-2 space-y-6">
          <div>
            <h1 class="text-4xl font-bold tracking-tight">Pablo Grobas Illobre</h1>
            <p class="mt-4 text-gray-700 leading-relaxed text-xl">
              Researcher with <strong>6+ years</strong> in <strong>computational quantum chemistry</strong>,
              specialized in <strong>QM/MM</strong> methodologies and scientific software in
              <strong>Python</strong>, <strong>C++</strong>, and <strong>Fortran</strong>. Passionate about
              <strong>drug discovery</strong>, machine learning, and cheminformatics.
            </p>
          </div>

          <div>
            <h2 class="mt-10 text-2xl font-bold">Technical Skills</h2>
            <ul class="mt-4 grid grid-cols-1 sm:grid-cols-2 gap-x-4 gap-y-1 text-xl text-gray-800">
              <li><b>Languages:</b> Python, C++, Fortran, Matlab</li>
              <li><b>Libraries:</b> NumPy, SciPy, TensorFlow, PyTorch</li>
              <li><b>Tools:</b> Git, Vim, VS Code</li>
              <li><b>Scripting:</b> Bash, Linux</li>
              <li><b>Scientific SW:</b> AMS, Gaussian</li>
              <li><b>HPC:</b> Cluster environments</li>
            </ul>
          </div>

          <div class="flex flex-wrap gap-3">
            <!-- Download CV -->
            <a href="/pdfs/GROBAS_CV_2025.pdf" download
               class="mt-5 px-4 py-2 rounded-xl bg-sky-600 text-white font-medium shadow hover:bg-sky-700 text-lg">
              ↓ Download CV (PDF)
            </a>

            <!-- Contact -->
            <button
              type="button"
              data-contact-trigger
              aria-haspopup="true"
              aria-expanded="false"
              class="mt-5 text-lg px-4 py-2 rounded-2xl bg-white shadow ring-1 ring-gray-200 hover:bg-gradient-to-br hover:from-sky-50 hover:to-indigo-50
                        hover:shadow-md hover:border-sky-300 transition
                        flex gap-4 p-4"
            >
              Contact
            </button>

            <!-- Scroll down -->
            <a href="#education"
               class="mt-5 text-lg px-4 py-2 rounded-xl bg-gray-100 text-gray-600 hover:text-black hover:bg-gray-200">
              ↓ Scroll to Interactive CV
            </a>
          </div>
        </div>
      </div>

      <!-- Placeholder for rest of the CV (scroll targets etc.) -->
      <div id="education" class="max-w-5xl mx-auto px-4 py-16">
        <h2 class="text-2xl font-bold mb-6">Education & Training</h2>
        <p class="text-gray-600">[Education content will scroll here and include a dynamic map]</p>
      </div>
    </section>
    """
  end
end
