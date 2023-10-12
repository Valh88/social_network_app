defmodule SocialNetworkAppWeb.Guardian.SetConnUser do
  import Plug.Conn
  alias SocialNetworkApp.Users
  alias SocialNetworkAppWeb.Guardian.ErrorResponsePlug

  def init(_ops) do
  end

  def call(conn, _ops) do
    if conn.assigns[:current_user] do
      conn
    else
      account_id = get_session(conn, :account_id)
      if account_id == nil, do: raise ErrorResponsePlug.Unauthorized
      user = Users.get_user_by_account_id(account_id)
      cond do
        account_id && user -> assign(conn, :current_user, user)
        true -> assign(conn, :current_user, nil)
      end
    end
  end
end
