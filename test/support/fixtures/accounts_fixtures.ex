defmodule SocialNetworkApp.AccountsFixtures do
  @moduledoc false


  def create_account_user_fixture() do
    {:ok, account} =
      %{
        email: "test@email.ru",
        password_hash: "test_password"
        }
      |> SocialNetworkApp.Accounts.create_account()
    account
  end

  
end
