import "phoenix_html"
import topbar from "../vendor/topbar"
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"

import { EduMap } from "./edu_map_hook"



// ---------------------------
// Custom LiveView Hooks
// ---------------------------
const Hooks = {}

Hooks.EduMap = EduMap


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
    video.loop = false
    video.style.opacity = "1"
    video.style.transition = "opacity 250ms linear"
    video.classList.add("opacity-100")
    still.classList.add("opacity-0")
    const showVideo = () => {
      video.style.opacity = "1"
      video.classList.add("opacity-100")
      still.classList.add("opacity-0")
      still.classList.remove("opacity-100")
    }
    const showStill = () => {
      video.classList.remove("opacity-100")
      still.classList.remove("opacity-0")
      still.classList.add("opacity-100")
    }
    const fadeNearEnd = () => {
      if (!Number.isFinite(video.duration) || video.duration <= 0) return
      const remaining = video.duration - video.currentTime
      if (remaining <= 5) {
        video.style.opacity = String(Math.max(0, remaining / 5))
      } else {
        video.style.opacity = "1"
      }
    }
    const hideAtEnd = () => {
      video.style.opacity = "0"
    }
    video.addEventListener("canplay", showVideo, { once: true })
    video.addEventListener("playing", showVideo)
    video.addEventListener("timeupdate", fadeNearEnd)
    video.addEventListener("ended", hideAtEnd)
    video.addEventListener("error", showStill)
    this._cleanup = () => {
      video.removeEventListener("playing", showVideo)
      video.removeEventListener("timeupdate", fadeNearEnd)
      video.removeEventListener("ended", hideAtEnd)
      video.removeEventListener("error", showStill)
    }
  },
  destroyed() {
    this._cleanup && this._cleanup()
  }
}

Hooks.HomeScrollCue = {
  mounted() {
    const targetSelector = this.el.dataset.scrollTarget
    const prefersReducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)")

    this._updateVisibility = () => {
      this.el.classList.toggle("is-hidden", window.scrollY > 24)
    }

    this._handleClick = event => {
      const target = targetSelector && document.querySelector(targetSelector)
      if (!target) return

      event.preventDefault()
      const targetTop = target.getBoundingClientRect().top + window.scrollY
      const offset = Math.min(28, window.innerHeight * 0.04)

      window.scrollTo({
        top: Math.max(0, targetTop - offset),
        behavior: prefersReducedMotion.matches ? "auto" : "smooth"
      })
    }

    this._readyTimer = window.setTimeout(() => {
      this.el.classList.add("is-ready")
    }, 2800)

    this.el.addEventListener("click", this._handleClick)
    window.addEventListener("scroll", this._updateVisibility, { passive: true })
    this._updateVisibility()
  },
  destroyed() {
    window.clearTimeout(this._readyTimer)
    this.el.removeEventListener("click", this._handleClick)
    window.removeEventListener("scroll", this._updateVisibility)
  }
}

Hooks.HomeTimeline = {
  mounted() {
    const reveal = () => this.el.classList.add("is-visible")

    if (!("IntersectionObserver" in window)) {
      reveal()
      return
    }

    this._observer = new IntersectionObserver(entries => {
      if (!entries.some(entry => entry.isIntersecting)) return

      reveal()
      this._observer.disconnect()
      this._observer = null
    }, {
      rootMargin: "0px 0px -18% 0px",
      threshold: 0.35
    })

    this._observer.observe(this.el)
  },
  destroyed() {
    this._observer && this._observer.disconnect()
  }
}

Hooks.RenderMath = {
  mounted() { this.render() },
  updated() { this.render() },
  render() {
    const el = document.querySelector("#article-body")
    if (!el || typeof window.renderMathInElement !== "function") return

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

    el.querySelectorAll("pre code.math, pre code.language-math").forEach(code => {
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

Hooks.BuildToc = {
  mounted() {
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

// ---------------------------
// LiveSocket bootstrapping
// ---------------------------

const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

const liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
  hooks: Hooks
})

// Topbar config
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0,0,0,.3)" })
window.addEventListener("phx:page-loading-start", () => topbar.show(300))
window.addEventListener("phx:page-loading-stop", () => topbar.hide())

// Connect LiveView
liveSocket.connect()

// Expose for console debugging
window.liveSocket = liveSocket

// Optional: phoenix_live_reload in dev only
if (typeof process !== "undefined" && process.env?.NODE_ENV === "development") {
  window.addEventListener("phx:live_reload:attached", ({ detail: reloader }) => {
    reloader.enableServerLogs()
    let keyDown
    window.addEventListener("keydown", e => keyDown = e.key)
    window.addEventListener("keyup", () => keyDown = null)
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
