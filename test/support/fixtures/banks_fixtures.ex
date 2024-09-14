defmodule Chequeit.BanksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Chequeit.Banks` context.
  """

  @doc """
  Generate a bank.
  """
  def bank_fixture(attrs \\ %{}) do
    {:ok, bank} =
      attrs
      |> Enum.into(%{

      })
      |> Chequeit.Banks.create_bank()

    bank
  end
end
