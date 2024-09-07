defmodule ChequeitWeb.UserRegistrationControllerTest do
  use ChequeitWeb.ConnCase, async: true

  import Chequeit.AccountFixtures

  describe "GET /auth/sign-up" do
    test "renders registration page", %{conn: conn} do
      conn = get(conn, ~p"/auth/sign-up")
      response = html_response(conn, 200)
      assert response =~ "Register"
      assert response =~ ~p"/auth/sign-in"
      assert response =~ ~p"/auth/sign-up"
    end

    test "redirects if already logged in", %{conn: conn} do
      conn = conn |> log_in_user(user_fixture()) |> get(~p"/auth/sign-up")

      assert redirected_to(conn) == ~p"/"
    end
  end

  describe "POST /auth/sign-up" do
    @tag :capture_log
    test "creates account and logs the user in", %{conn: conn} do
      email = unique_user_email()

      conn =
        post(conn, ~p"/auth/sign-up", %{
          "user" => valid_user_attributes(email: email)
        })

      assert get_session(conn, :user_token)
      assert redirected_to(conn) == ~p"/"

      # Now do a logged in request and assert on the menu
      conn = get(conn, ~p"/")
      response = html_response(conn, 200)
      assert response =~ email
      assert response =~ ~p"/auth/settings"
      assert response =~ ~p"/auth/log_out"
    end

    test "render errors for invalid data", %{conn: conn} do
      conn =
        post(conn, ~p"/auth/sign-up", %{
          "user" => %{"email" => "with spaces", "password" => "too short"}
        })

      response = html_response(conn, 200)
      assert response =~ "Register"
      assert response =~ "must have the @ sign and no spaces"
      assert response =~ "should be at least 12 character"
    end
  end
end
