defmodule ChequeitWeb.DashboardHTML do
  @moduledoc """
  This module contains pages rendered by DashboardController.

  See the `page_html` directory for all templates available.
  """
  use ChequeitWeb, :html

  embed_templates "page_html/*"
end
