defmodule PersonalWebsiteWeb.Router do
  use PersonalWebsiteWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PersonalWebsiteWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Classic HTTP routes (controller + template)
  # Use when rendering a static or pre-rendered page with no interactivity
  #scope "/", PersonalWebsiteWeb do
  #  pipe_through :browser
  #
  #  get "/", PageController, :home
  #end

  # LiveView routes (interactive, real-time via WebSocket)
  # Use when you need dynamic updates or richer interactivity (no JS needed)
  scope "/", PersonalWebsiteWeb do
    pipe_through :browser

    live "/", HomeLive
    live "/software", SoftwareLive

    live "/notes", NotesLive
    live "/notes/:slug", NoteLive

    # When someone visits /about, Phoenix will call the about/2 function in your PageController.
    # This is different from live "/", which uses a LiveView module directly.
    get  "/about", PageController, :about
  end


  # Other scopes may use custom stacks.
  # scope "/api", PersonalWebsiteWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard in development
  if Application.compile_env(:personal_website, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PersonalWebsiteWeb.Telemetry
    end
  end
end
