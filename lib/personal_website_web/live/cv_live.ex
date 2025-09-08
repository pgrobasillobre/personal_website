defmodule PersonalWebsiteWeb.CVLive do
  use PersonalWebsiteWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    section = "postdoc"

    socket =
      socket
      |> assign(
        page_title: "CV — Pablo Grobas Illobre",
        meta_description: "Interactive CV and downloadable PDF for Pablo Grobas Illobre.",
        selected_section: section
      )
      |> push_event("edu:markers", %{markers: markers_for(section)})

    {:ok, socket}
  end

  @impl true
  def handle_event("select_section", %{"section" => section}, socket) do
    {:noreply,
     socket
     |> assign(selected_section: section)
     |> push_event("edu:markers", %{markers: markers_for(section)})}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <section class="bg-white">
      <div class="max-w-7xl mx-auto p-6 space-y-6">
        <h1 class="text-5xl font-semibold mt-6 mb-0">Curriculum Vitae</h1>
      </div>

      <!-- Hero-style layout -->
      <div class="max-w-7xl mx-auto px-4 py-0 grid grid-cols-1 md:grid-cols-3 gap-8 items-start">
        <!-- Photo -->
        <div class="mx-auto mt-15 h-60 w-60 md:h-70 md:w-70 lg:h-80 lg:w-80 rounded-full p-[5px]
                    bg-gradient-to-br from-cyan-400 to-indigo-500 shadow-xl ring-1 ring-black/5">
          <img
            src="/images/profile.jpg"
            alt="Pablo Grobas Illobre"
            class="h-full w-full rounded-full object-cover"
          />
          <div class="flex flex-wrap gap-3">
            <a href="/pdfs/GROBAS_CV_2025.pdf"
               download
               class="mt-13 px-4 py-2 rounded-xl bg-sky-600 text-white font-medium shadow hover:bg-sky-700 text-lg">
              ↓ Download CV
            </a>
            <button type="button"
                    data-contact-trigger
                    class="mt-13 text-lg px-4 py-2 rounded-2xl bg-white shadow ring-1 ring-gray-200 hover:bg-gradient-to-br hover:from-sky-50 hover:to-indigo-50 hover:shadow-md hover:border-sky-300 transition flex gap-4 p-4">
              Contact
            </button>
          </div>
        </div>

        <!-- Bio + Skills -->
        <div class="mt-15 md:col-span-2 space-y-6">
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
        </div>
      </div>

      <!-- Interactive Education Section -->
      <div id="education" class="max-w-7xl mx-auto px-4 py-16">
        <h2 class="text-3xl font-bold mt-20 mb-10">Experience & Training</h2>

        <!-- Buttons -->
        <div class="flex flex-wrap gap-3 mb-8">
          <button phx-click="select_section" phx-value-section="postdoc" class="btn btn-outline">Postdoc</button>
          <button phx-click="select_section" phx-value-section="phd" class="btn btn-outline">Ph.D.</button>
          <button phx-click="select_section" phx-value-section="msc" class="btn btn-outline">M.Sc.</button>
          <button phx-click="select_section" phx-value-section="research" class="btn btn-outline">Research Assistant</button>
          <button phx-click="select_section" phx-value-section="bsc" class="btn btn-outline">B.Sc.</button>
        </div>

        <!-- Grid: Map and Details -->
        <div class="grid md:grid-cols-3 gap-10 items-start">
          <!-- Left: Map -->
          <div class="rounded-xl border p-4 bg-white shadow-sm h-96">
            <!-- IMPORTANT: keep the map DOM alive across patches -->
            <div id="cv-edu-map" phx-hook="EduMap" phx-update="ignore" class="w-full h-full"></div>
          </div>

          <!-- Right: Education content -->
          <div class="md:col-span-2 space-y-10">
            <%= if @selected_section == "postdoc" do %>
              <div>
                <h3 class="text-xl font-bold">Postdoctoral Researcher</h3>
                <p class="text-gray-700">Scuola Normale Superiore · 02/2025 – Present · Pisa, Italy</p>
                <ul class="list-disc ml-5 text-gray-700 mt-2">
                  <li>QM/MM quantum chemistry software (C++/Fortran)</li>
                  <li>Python for machine learning, stats, visualization</li>
                  <li>Topics: SERS, ROA, plasmonics, EET</li>
                </ul>
              </div>
            <% end %>

            <%= if @selected_section == "phd" do %>
              <div>
                <h3 class="text-xl font-bold">Ph.D. (cum laude) in Molecular Sciences</h3>
                <p class="text-gray-700">Scuola Normale Superiore · 11/2020 – 01/2025 · Pisa, Italy</p>
                <p class="mt-2 text-gray-700">
                  Thesis: <em>Modeling Atomistic Nanoplasmonics</em><br />
                  Supervisor: Chiara Cappelli
                </p>
              </div>
            <% end %>

            <%= if @selected_section == "msc" do %>
              <div>
                <h3 class="text-xl font-bold">M.Sc. in Theoretical Chemistry and Computational Modeling</h3>
                <p class="text-gray-700">Université Paul Sabatier · 09/2018 – 08/2020 · Toulouse, France</p>
                <ul class="list-disc ml-5 text-gray-700 mt-2">
                  <li>Thesis at University of Trieste (Fortran dev)</li>
                  <li>Visiting: Autonomous University of Madrid</li>
                  <li>Internship: Okayama University (MD sims)</li>
                </ul>
              </div>
            <% end %>

            <%= if @selected_section == "bsc" do %>
              <div>
                <h3 class="text-xl font-bold">B.Sc. in Chemistry</h3>
                <p class="text-gray-700">University of A Coruña · 09/2014 – 07/2018 · A Coruña, Spain</p>
                <p class="text-gray-700 mt-2">Erasmus Exchange: University of Oslo (2016)</p>
              </div>
            <% end %>

            <%= if @selected_section == "research" do %>
              <div>
                <h3 class="text-xl font-bold">Research Assistant</h3>
                <p class="text-gray-700">Instituto de Tecnología Química · 07–08/2019 · Valencia, Spain</p>
                <p class="text-gray-700 mt-2">
                  MD for sugar separation in the food industry<br />
                  Supervisor: Germán I. Sastre Navarro
                </p>
              </div>
            <% end %>
          </div>
        </div>
      </div>
    </section>
    """
  end

  # -------------------------
  # Marker data per section
  # -------------------------
  defp markers_for("postdoc"), do: [
    %{lat: 43.716, lng: 10.403, label: "Pisa · SNS", offset: %{dlat: 0.7, dlng: 1.0}}
  ]

  defp markers_for("phd"), do: [
    %{lat: 43.716, lng: 10.403, label: "Pisa · SNS", offset: %{dlat: 0.7, dlng: 1.0}}
  ]

  defp markers_for("msc"), do: [
    %{lat: 43.6045, lng: 1.4440, label: "Toulouse · UPS", offset: %{dlat: 0.6, dlng: 0.9}},
    %{lat: 45.6495, lng: 13.7768, label: "Trieste · Units", offset: %{dlat: 0.6, dlng: -0.9}},
    %{lat: 40.4168, lng: -3.7038, label: "Madrid · UAM", offset: %{dlat: -0.6, dlng: -0.9}},
    %{lat: 34.6550, lng: 133.9190, label: "Okayama · Okayama University", offset: %{dlat: 0.6, dlng: 0.9}}
  ]

  defp markers_for("bsc"), do: [
    %{lat: 43.3623, lng: -8.4115, label: "A Coruña · UDC", offset: %{dlat: 0.6, dlng: 0.9}},
    %{lat: 59.9139, lng: 10.7522, label: "Oslo · UiO", offset: %{dlat: -0.6, dlng: 0.9}}
  ]

  defp markers_for("research"), do: [
    %{lat: 39.4699, lng: -0.3763, label: "Valencia · ITQ", offset: %{dlat: 0.6, dlng: 0.9}}
  ]

  defp markers_for(_), do: []
end
