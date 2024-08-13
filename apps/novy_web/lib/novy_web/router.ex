defmodule NovyWeb.Router do
  use NovyWeb, :router

  import NovyWeb.DiscordAuth, only: [fetch_discord_user: 2]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {NovyWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_discord_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", NovyWeb do
    pipe_through :browser

    # get "/", PageController, :home
    live_session :default,
      on_mount: {NovyWeb.DiscordAuth, :mount_current_user} do
      live "/", HomeLive
    end
  end

  scope "/auth", NovyWeb do
    pipe_through :browser

    get "/discord", DiscordController, :request
    get "/discord/callback", DiscordController, :callback
    delete "/discord/logout", DiscordController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", NovyWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:novy_web, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: NovyWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
