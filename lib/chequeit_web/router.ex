defmodule ChequeitWeb.Router do
  use ChequeitWeb, :router

  import ChequeitWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ChequeitWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
    # plug ChequeitWeb.SetUser
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
    plug :fetch_current_user
  end

  # Other scopes may use custom stacks.
  # scope "/api", ChequeitWeb do
  #   pipe_through :api
  # end

  scope "/", ChequeitWeb do
    pipe_through [:auth, :redirect_if_user_is_authenticated]

    get "/auth/sign-up", UserRegistrationController, :new
    post "/auth/sign-up", UserRegistrationController, :create
    get "/auth/sign-in", UserSessionController, :new
    post "/auth/sign-in", UserSessionController, :create
    get "/auth/reset_password", UserResetPasswordController, :new
    post "/auth/reset_password", UserResetPasswordController, :create
    get "/auth/reset_password/:token", UserResetPasswordController, :edit
    put "/auth/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", ChequeitWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/", DashboardController, :dashboard
    get "/history", TransactionsController, :transactions
    get "/transfer", TransferController, :transfer
    get "/banks", BanksController, :banks
    get "/link-bank", PlaidController, :index
    post "/link-bank", PlaidController, :create
    get "/auth/settings", UserSettingsController, :edit
    put "/auth/settings", UserSettingsController, :update
    get "/auth/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", ChequeitWeb do
    pipe_through [:browser]

    delete "/auth/log_out", UserSessionController, :delete
    get "/auth/confirm", UserConfirmationController, :new
    post "/auth/confirm", UserConfirmationController, :create
    get "/auth/confirm/:token", UserConfirmationController, :edit
    post "/auth/confirm/:token", UserConfirmationController, :update
  end

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
