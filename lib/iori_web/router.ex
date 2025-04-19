defmodule IoriWeb.Router do
  use IoriWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {IoriWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", IoriWeb do
    pipe_through :browser

    # Handle root path
    get "/", PageController, :index

    # Handle site paths
    get "/*path", PageController, :index
  end

  # Add live reload for development
  if Mix.env() == :dev do
    scope "/" do
      pipe_through :browser
      forward "/phoenix/live_reload", Phoenix.LiveReloader
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", IoriWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:iori, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: IoriWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
