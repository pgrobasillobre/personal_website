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
      |> push_event("edu:markers", %{
        markers: markers_for(section),
        view: view_for(section)
      })

    {:ok, socket}
  end

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

        <!-- Buttons (stateful) -->
        <div class="flex flex-wrap gap-2 mb-8">
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
              class={[
                "px-3 py-1.5 rounded-lg border text-sm font-medium transition-colors",
                "focus:outline-none focus-visible:ring-2 focus-visible:ring-slate-400/60",
                @selected_section == sect &&
                  "bg-slate-200 text-slate-900 border-slate-400 hover:bg-slate-300",
                @selected_section != sect &&
                  "bg-white text-slate-700 border-slate-300 hover:bg-slate-100"
              ]}>
              <%= label %>
            </button>
          <% end %>
        </div>

        <!-- Grid: Map and Details -->
        <div class="grid md:grid-cols-3 gap-10 items-start">
          <!-- Left: Map -->
          <div class="rounded-xl border p-4 bg-white shadow-sm h-96">
            <!-- Keep the map DOM alive across patches -->
            <div id="cv-edu-map" phx-hook="EduMap" phx-update="ignore" class="w-full h-full"></div>
          </div>

          <!-- Right: Education content -->
          <div class="md:col-span-2 space-y-10">
            <%= if @selected_section == "postdoc" do %>
              <div>
                <div class="flex flex-wrap items-baseline gap-2">
                  <h3 class="text-xl font-bold">Postdoctoral Researcher,</h3>
                  <span class="font-serif italic text-lg text-slate-700">Scuola Normale Superiore (Pisa, Italy)</span>
                </div>
                <p class="font-serif italic text-lg text-slate-700">02/2025 – Present</p>
                <p class="mt-5 text-gray-700 text-lg leading-relaxed">
                  Currently developing <strong>QM/MM quantum chemistry software</strong> in <strong>C++</strong> and <strong>Fortran</strong> in collaboration with the
                  <span class="font-serif italic">Software for Chemistry &amp; Materials</span> company. This work is complemented by
                  <strong>Python programming</strong> for <strong>machine learning</strong>, <strong>data analysis</strong>, <strong>statistics</strong>, and <strong>visualization</strong>.
                </p>

                <p class="text-gray-700 text-lg leading-relaxed mt-3">
                  My research integrates intensive <strong>software development</strong> to investigate:
                </p>
                <ul class="list-disc ml-5 text-gray-700 mt-2 space-y-1">
                  <li><strong>QM/MM Surface-Enhanced Spectroscopies</strong>: fluorescence, Raman scattering, Raman optical activity.</li>
                  <li><strong>Plasmonic Materials</strong>: graphene &amp; metal nanoparticles.</li>
                  <li><strong>Plasmon-Mediated Electronic Energy Transfer</strong>.</li>
                </ul>
              </div>
            <% end %>

            <%= if @selected_section == "phd" do %>
              <div>
                <div class="flex flex-wrap items-baseline gap-2">
                <h3 class="text-xl font-bold">
                  Ph.D. in Methods and Models for Molecular Sciences (<span class="font-serif italic font-bold">cum laude</span>),
                </h3>
                  <span class="font-serif italic text-lg text-slate-700">Scuola Normale Superiore (Pisa, Italy)</span>
                </div>
                <p class="font-serif italic text-lg text-slate-700">11/2020 – 01/2025</p>
                <ul class="list-disc ml-5 text-gray-700 mt-2 space-y-1">
                  <li><span class="font-semibold">Thesis:</span> <em>Modeling Atomistic Nanoplasmonics</em></li>
                  <li><span class="font-semibold">Supervisor:</span> Chiara Cappelli</li>
                </ul>
              </div>
            <% end %>

            <%= if @selected_section == "msc" do %>
              <div>
                <div class="flex flex-wrap items-baseline gap-2">
                  <h3 class="text-xl font-bold">M.Sc. in Theoretical Chemistry &amp; Computational Modeling,</h3>
                  <span class="font-serif italic text-lg text-slate-700">Université Paul Sabatier (Toulouse, France)</span>
                </div>
                <p class="font-serif italic text-lg text-slate-700">09/2018 – 08/2020</p>
                <ul class="list-disc ml-5 text-gray-700 mt-2 space-y-1">
                  <li>Thesis at University of Trieste (Fortran development)</li>
                  <li>Visiting student at Autonomous University of Madrid</li>
                  <li>Internship at Okayama University (MD simulations)</li>
                </ul>
              </div>
            <% end %>

            <%= if @selected_section == "bsc" do %>
              <div>
                <div class="flex flex-wrap items-baseline gap-2">
                  <h3 class="text-xl font-bold">B.Sc. in Chemistry,</h3>
                  <span class="font-serif italic text-lg text-slate-700">University of A Coruña (A Coruña, Spain)</span>
                </div>
                <p class="font-serif italic text-lg text-slate-700">09/2014 – 07/2018</p>
                <ul class="list-disc ml-5 text-gray-700 mt-2 space-y-1">
                  <li>Erasmus Exchange: University of Oslo (2016)</li>
                </ul>
              </div>
            <% end %>

            <%= if @selected_section == "research" do %>
              <div>
                <div class="flex flex-wrap items-baseline gap-2">
                  <h3 class="text-xl font-bold">Research Assistant,</h3>
                  <span class="font-serif italic text-lg text-slate-700">Instituto de Tecnología Química (Valencia, Spain)</span>
                </div>
                <p class="font-serif italic text-lg text-slate-700">07/2019 – 08/2019</p>
                <ul class="list-disc ml-5 text-gray-700 mt-2 space-y-1">
                  <li>MD for sugar separation in the food industry</li>
                  <li><span class="font-semibold">Supervisor:</span> Germán I. Sastre Navarro</li>
                </ul>
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
    %{lat: 45.6495, lng: 13.7768, label: "Trieste · UniTS", offset: %{dlat: 0.6, dlng: -0.9}},
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

  # -------------------------
  # View per section (country-level)
  # -------------------------
  defp view_for("postdoc"), do: %{center: [42.5, 12.5], zoom: 5}   # Italy
  defp view_for("phd"), do: %{center: [42.5, 12.5], zoom: 5}   # Italy
  defp view_for("research"), do: %{center: [40.2, -3.5], zoom: 5}  # Spain (mainland)
  defp view_for(_), do: nil
end
