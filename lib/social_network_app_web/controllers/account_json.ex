defmodule SocialNetworkAppWeb.AccountJSON do

  def account_token(%{user: account, token: token}) do
    %{
      account: %{
        email: account.email,
        token: token
      }
    }
  end

  def logout(%{}) do
    %{
      status: "success"
    }
  end

  def current_user(%{user: user}) do
    user
  end
end
