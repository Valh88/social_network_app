defmodule SocialNetworkAppWeb.AccountController do
  use SocialNetworkAppWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias SocialNetworkApp.Users.Subscribe
  alias SocialNetworkApp.Users
  alias SocialNetworkApp.Users.User
  alias SocialNetworkApp.Accounts.Account
  alias SocialNetworkApp.Accounts
  alias SocialNetworkAppWeb.Guardian.GuardianAuth
  alias SocialNetworkAppWeb.FallbackController
  alias OpenApiSpex.{Schema, Reference}
  alias SocialNetworkAppWeb.Schemas

  action_fallback FallbackController
  plug OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true

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

  @spec current_user(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def current_user(conn, _params) do
    user_map = Users.get_full_user_info(conn.assigns[:current_user].id)
    conn
    |> put_status(:ok)
    |> render(:current_user, %{user: user_map})
  end

  @spec subscribe(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def subscribe(conn, %{"subscribe" => %{"on_sub_id" => on_sub_id}}) do
    current_user = conn.assigns[:current_user]
    with %User{} = _user <- check_user(on_sub_id),
      {:ok, %Subscribe{} = subscribe} = Users.subscribe_to_user(
        %{subscriber_id: current_user.id, on_sub_id: on_sub_id}
        ) do
      conn
      |> put_status(:ok)
      |> render(:subscribe, %{sub: subscribe})
    end
  end

  @spec unsubscribe(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def unsubscribe(conn, %{"id" => on_sub_id}) do
    current_user = conn.assigns[:current_user]
    with %User{} = _user <- check_user(on_sub_id),
        {:ok, %Subscribe{} = _unsub} <- Users.unsubscribe_to_user(
          %{subscriber_id: current_user.id, on_sub_id: on_sub_id}
        ) do
      conn
      |> send_resp(:no_content, "")
    end
  end

  @spec check_user(binary()) :: struct() | {:error, :not_found}
  defp check_user(on_sub_id) do
    case Users.get_user_by_user_id(on_sub_id) do
      %User{} = user -> user
      nil -> {:error, :not_found}
    end
  end

  operation :show,
    summary: "Show user.",
    description: "Show a user by ID.",
    parameters: [
      id: [
        in: :path,
        # `:type` can be an atom, %Schema{}, or %Reference{}
        type: %Schema{type: :string, minimum: 1},
        description: "User ID",
        example: "58c1b9d6-dbe9-42e4-adf1-1bc223371f50",
        required: true
      ]
    ],
    responses: [
      ok: {"User", "application/json", Schemas.UserResponse}
    ]

  def show(conn, %{"id" => id}) do
    with user_map <- Users.get_full_user_info(id) do
      conn
      |> put_status(:ok)
      |> render(:user, user: user_map)
    end
  end
end
