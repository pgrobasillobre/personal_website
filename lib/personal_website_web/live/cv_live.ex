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
        <div class="mx-auto mt-3 h-60 w-60 md:h-70 md:w-70 lg:h-80 lg:w-80 rounded-full p-[5px]  <!-- Increased sizes -->
                    bg-gradient-to-br from-cyan-400 to-indigo-500 shadow-xl ring-1 ring-black/5">
          <img
            src="/images/profile.jpg"
            alt="Pablo Grobas Illobre"
            class="h-full w-full rounded-full object-cover"
          />

                  <div class="flex flex-wrap gap-3">
            <!-- Download CV -->
            <a href="/pdfs/GROBAS_CV_2025.pdf" download
               class="mt-13 px-4 py-2 rounded-xl bg-sky-600 text-white font-medium shadow hover:bg-sky-700 text-lg">
              ↓ Download CV
            </a>

            <!-- Contact -->
            <button
              type="button"
              data-contact-trigger
              aria-haspopup="true"
              aria-expanded="false"
              class="mt-13 text-lg px-4 py-2 rounded-2xl bg-white shadow ring-1 ring-gray-200 hover:bg-gradient-to-br hover:from-sky-50 hover:to-indigo-50
                        hover:shadow-md hover:border-sky-300 transition
                        flex gap-4 p-4"
            >
              Contact
            </button>

          </div>
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

            <!-- Scroll down -->
            <a href="#education"
               class="mt-5 text-lg px-4 py-2 rounded-xl bg-gray-100 text-gray-600 hover:text-black hover:bg-gray-200">
              ↓ Scroll to Interactive CV
            </a>
          </div>
        </div>
      </div>

      <!-- Placeholder for rest of the CV (scroll targets etc.) -->
      <div id="education" class="max-w-7xl mx-auto px-4 py-16">
        <h2 class="text-3xl font-bold mb-10">Education & Training</h2>

        <!-- Buttons to scroll to each entry -->
        <div class="flex flex-wrap gap-3 mb-8">
          <a href="#edu-postdoc" class="btn btn-outline">Postdoc</a>
          <a href="#edu-phd" class="btn btn-outline">Ph.D.</a>
          <a href="#edu-msc" class="btn btn-outline">M.Sc.</a>
          <a href="#edu-bsc" class="btn btn-outline">B.Sc.</a>
          <a href="#edu-research" class="btn btn-outline">Research Assistant</a>
        </div>

        <!-- Grid layout with map + content -->
        <div class="grid md:grid-cols-3 gap-10 items-start">
          <!-- Left: Map -->
          <div class="rounded-xl border p-4 bg-white shadow-sm h-96 flex items-center justify-center">
            <p class="text-gray-500 text-center">
              🗺️ Map goes here<br />
              (Pisa, Toulouse, Oslo, Trieste, Madrid, etc.)
            </p>
          </div>

          <!-- Right: Education cards -->
          <div class="md:col-span-2 space-y-10">

            <!-- Postdoc -->
            <div id="edu-postdoc" class="scroll-mt-20">
              <h3 class="text-xl font-bold">Postdoctoral Researcher</h3>
              <p class="text-gray-700">Scuola Normale Superiore · 02/2025 – Present · Pisa, Italy</p>
              <ul class="list-disc ml-5 text-gray-700 mt-2">
                <li>QM/MM quantum chemistry software (C++/Fortran)</li>
                <li>Python for machine learning, stats, visualization</li>
                <li>Topics: SERS, ROA, plasmonics, EET</li>
              </ul>
            </div>

            <!-- Ph.D. -->
            <div id="edu-phd" class="scroll-mt-20">
              <h3 class="text-xl font-bold">Ph.D. (cum laude) in Molecular Sciences</h3>
              <p class="text-gray-700">Scuola Normale Superiore · 11/2020 – 01/2025 · Pisa, Italy</p>
              <p class="mt-2 text-gray-700">
                Thesis: <em>Modeling Atomistic Nanoplasmonics</em><br />
                Supervisor: Chiara Cappelli
              </p>
            </div>

            <!-- M.Sc. -->
            <div id="edu-msc" class="scroll-mt-20">
              <h3 class="text-xl font-bold">M.Sc. in Theoretical Chemistry and Computational Modeling</h3>
              <p class="text-gray-700">Université Paul Sabatier · 09/2018 – 08/2020 · Toulouse, France</p>
              <ul class="list-disc ml-5 text-gray-700 mt-2">
                <li>Thesis at University of Trieste (Fortran dev)</li>
                <li>Visiting: Autonomous University of Madrid</li>
                <li>Internship: Okayama University (MD sims)</li>
              </ul>
            </div>

            <!-- Research Assistant -->
            <div id="edu-research" class="scroll-mt-20">
              <h3 class="text-xl font-bold">Research Assistant</h3>
              <p class="text-gray-700">Instituto de Tecnología Química · 07–08/2019 · Valencia, Spain</p>
              <p class="text-gray-700 mt-2">
                MD for sugar separation in the food industry<br />
                Supervisor: Germán I. Sastre Navarro
              </p>
            </div>

            <!-- B.Sc. -->
            <div id="edu-bsc" class="scroll-mt-20">
              <h3 class="text-xl font-bold">B.Sc. in Chemistry</h3>
              <p class="text-gray-700">University of A Coruña · 09/2014 – 07/2018 · A Coruña, Spain</p>
              <p class="text-gray-700 mt-2">Erasmus Exchange: University of Oslo (2016)</p>
            </div>

          </div>
        </div>
      </div>

    </section>
    """
  end
end
