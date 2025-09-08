// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//
// If you have dependencies that try to import CSS, esbuild will generate a separate `app.css` file.
// To load it, simply add a second `<link>` to your `root.html.heex` file.

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import { hooks as colocatedHooks } from "phoenix-colocated/personal_website"
import topbar from "../vendor/topbar"

// ---------------------------
// Custom LiveView Hooks
// ---------------------------
const Hooks = {}

// Build a simple in-page TOC from h2/h3 inside #article-body
Hooks.BuildToc = {
  mounted() {
    // this.el is the <nav id="toc"> element
    const article = document.querySelector("#article-body")
    const tocList = this.el.querySelector("ul")
    if (!article || !tocList) return

    const headings = article.querySelectorAll("h2, h3")
    headings.forEach(h => {
      const id = h.getAttribute("id")
      if (!id) return

      const li = document.createElement("li")
      const a = document.createElement("a")
      a.href = `#${id}`
      a.textContent = h.textContent
      a.className = "text-slate-600 hover:text-slate-900 dark:text-slate-300 dark:hover:text-white"
      if (h.tagName === "H3") li.className = "pl-4"
      li.appendChild(a)
      tocList.appendChild(li)

      // Add a tiny ¶ anchor that appears on hover
      if (!h.querySelector("a.anchor")) {
        const anchor = document.createElement("a")
        anchor.href = `#${id}`
        anchor.textContent = "¶"
        anchor.className = "anchor opacity-0 ml-2 text-sky-500 transition-opacity"
        h.appendChild(anchor)
        h.addEventListener("mouseenter", () => anchor.classList.remove("opacity-0"))
        h.addEventListener("mouseleave", () => anchor.classList.add("opacity-0"))
      }
    })
  }
}


let Hooks = window.Hooks || {}
Hooks.CVPrint = {
  mounted() {
    this.el.addEventListener("click", () => window.print())
  }
}


Hooks.HeroVideo = {
  mounted() {
    const video = this.el.querySelector("#hero-video-el")
    const still = this.el.querySelector("#hero-still")
    if (!video || !still) return

    // Ensure initial state: video visible, still hidden
    video.classList.add("opacity-100")
    still.classList.add("opacity-0")

    const showVideo = () => {
      video.classList.add("opacity-100")
      still.classList.add("opacity-0")
      still.classList.remove("opacity-100")
    }

    const showStill = () => {
      video.classList.remove("opacity-100") // fades video out
      still.classList.remove("opacity-0")
      still.classList.add("opacity-100")    // fades still in
    }

    // If you want to re-assert visibility when the video is ready:
    video.addEventListener("canplay", showVideo, { once: true })
    // When the video ends, reveal the still underneath
    video.addEventListener("ended", showStill)

    this._cleanup = () => {
      video.removeEventListener("ended", showStill)
    }
  },
  destroyed() {
    this._cleanup && this._cleanup()
  }
}

// Render LaTeX using KaTeX (expects KaTeX + auto-render to be loaded via <script> tags)
Hooks.RenderMath = {
  mounted() { this.render() },
  updated() { this.render() },
  render() {
    const el = document.querySelector("#article-body")
    if (!el) return

    // Keep supporting $...$, $$...$$, \(...\), \[...\]
    if (typeof window.renderMathInElement === "function") {
      window.renderMathInElement(el, {
        delimiters: [
          { left: "$$", right: "$$", display: true },
          { left: "$", right: "$", display: false },
          { left: "\\(", right: "\\)", display: false },
          { left: "\\[", right: "\\]", display: true }
        ],
        throwOnError: false,
        strict: "warn",
        errorCallback: console.warn
      })
    }

    // NEW: render ```math fenced blocks (avoids Markdown mangling)
    el.querySelectorAll('pre code.math, pre code.language-math').forEach(code => {
      const tex = (code.textContent || "").trim()
      const out = document.createElement("div")
      try {
        window.katex.render(tex, out, { displayMode: true })
        code.closest("pre").replaceWith(out)
      } catch (err) {
        console.warn("KaTeX render error:", err, "for:", tex)
      }
    })
  }
}

// ---------------------------
// LiveSocket bootstrapping
// ---------------------------
const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

const liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
  // Merge colocated hooks with our custom ones.
  hooks: { ...colocatedHooks, ...Hooks }
})

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
let liveSocket = new LiveSocket("/live", Phoenix.Socket, { hooks: Hooks /* ...rest */ })
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

// The lines below enable quality of life phoenix_live_reload
// development features:
//
//     1. stream server logs to the browser console
//     2. click on elements to jump to their definitions in your code editor
//
if (process.env.NODE_ENV === "development") {
  window.addEventListener("phx:live_reload:attached", ({ detail: reloader }) => {
    // Enable server log streaming to client.
    // Disable with reloader.disableServerLogs()
    reloader.enableServerLogs()

    // Open configured PLUG_EDITOR at file:line of the clicked element's HEEx component
    //
    //   * click with "c" key pressed to open at caller location
    //   * click with "d" key pressed to open at function component definition location
    let keyDown
    window.addEventListener("keydown", e => keyDown = e.key)
    window.addEventListener("keyup", _e => keyDown = null)
    window.addEventListener("click", e => {
      if (keyDown === "c") {
        e.preventDefault()
        e.stopImmediatePropagation()
        reloader.openEditorAtCaller(e.target)
      } else if (keyDown === "d") {
        e.preventDefault()
        e.stopImmediatePropagation()
        reloader.openEditorAtDef(e.target)
      }
    }, true)

    window.liveReloader = reloader
  })
}