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

  def subscribe(%{sub: sub}) do
    %{
      status: "success",
      to_sub: sub.on_sub_id
    }
  end

  def user(%{user: user}) do
    %{
      data: user
    }
  end
end
