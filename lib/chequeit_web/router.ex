defmodule ChequeitWeb.Router do
  use ChequeitWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ChequeitWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug ChequeitWeb.SetUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ChequeitWeb.Layouts, :auth}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", ChequeitWeb do
    pipe_through [:browser]

    get "/", DashboardController, :dashboard
    delete "/", DashboardController, :log_out
    get "/history", TransactionsController, :transactions
    get "/transfer", TransferController, :transfer
    get "/banks", BanksController, :banks

    delete "/log-out", UserSessionController, :delete
  end


  scope "/auth", ChequeitWeb do
    pipe_through  [:auth]

    get "/sign-in", UserSessionController, :index
    post "/sign-in", UserSessionController, :create
    get "/sign-up", UserRegistrationController, :index
    post "/sign-up", UserRegistrationController, :create
    get "/link-bank", PlaidController, :index
    post "/link-bank", PlaidController, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", ChequeitWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:chequeit, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ChequeitWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
