defmodule SocialNetworkApp.AccountsFixtures do
  @moduledoc false


  def create_account_user_fixture(params) do
    {:ok, account} =
      SocialNetworkApp.Accounts.create_account(params)
    account
  end

  def create_picture_fixture(user, params) do
    SocialNetworkApp.Pictures.save_all_to_picture(user, params)
  end
end
