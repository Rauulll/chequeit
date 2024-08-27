defmodule ChequeitWeb.PlaidHTML do
  use ChequeitWeb, :html

  def index(assigns) do
    ~H"""
    <section class="flex-center size-full max-sm:px-6">
      <section class="auth-form">
        <header class="flex flex-col gap-5 md:gap-8">
          <.link navigate={~p"/"} class="mb-12 cursor-pointer flex items-center gap-2">
            <img src={~p"/images/logo.svg"} alt="logo" class="size-[24px] max-xl:size-14" />
            <h1 class="text-30 font-ibm-plex-serif font-bold text-black-1">ChequeIt</h1>
          </.link>
          <div class="flex flex-col gap-1 md:gap-3">
            <h1 class="text-24 lg:text-36 font-semibold text-gray-900">
              Sign Up
            </h1>
            <p class="text-16 font-normal text-gray-600">
              Link your bank
            </p>
          </div>
        </header>
        <button phx-click="pushEvent('navigate', '/')" method="post" class="plaidlink-primary">Connect Bank</button>
      </section>
    </section>
    """
  end
end
