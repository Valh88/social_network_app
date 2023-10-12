defmodule SocialNetworkAppWeb.AccountController do
  use SocialNetworkAppWeb, :controller
  alias SocialNetworkApp.Users
  alias SocialNetworkApp.Users.User
  alias SocialNetworkApp.Accounts.Account
  alias SocialNetworkApp.Accounts
  alias SocialNetworkAppWeb.Guardian.GuardianAuth
  alias SocialNetworkAppWeb.FallbackController

  action_fallback FallbackController

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"account" => params}) do
    %{"email" => email, "password" => password} = params
    with {:ok, %Account{} = account} <- Accounts.create_account(%{email: email, password_hash: password}),
          {:ok, %User{} = _user} <- Users.create_user(account, %{account_id: account.id}) do
      authenticate(conn, email, password)
    end
  end

  @spec login(Plug.Conn.t(), map()) :: {:error, :not_found} | Plug.Conn.t()
  def login(conn, %{"email" => email, "password" => password}) do
    authenticate(conn, email, password)
  end

  defp authenticate(conn, email, pass) do
    case GuardianAuth.authenticate(email, pass) do
      {:ok, account, token} ->
        conn
        |> Plug.Conn.put_session(:account_id, account.id)
        |> put_status(:ok)
        |> render(:account_token, %{user: account, token: token})
      {:error, _} ->
        {:error, :not_found}
    end
  end

  @spec logout(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def logout(conn, _params) do
    GuardianAuth.Plug.current_token(conn)
    |> GuardianAuth.revoke()

    conn
    |> Plug.Conn.clear_session()
    |> put_status(:ok)
    |> render(:logout, %{})
  end

  @spec current_user(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def current_user(conn, _params) do
    user_map = Users.get_full_user_info(conn.assigns[:current_user].id)
    conn
    |> put_status(:ok)
    |> render(:current_user, %{user: user_map})
  end
end
