defmodule SocialNetworkApp.AccountsTest do
  use SocialNetworkApp.DataCase

  alias SocialNetworkApp.Products

  describe "accounts" do
    alias SocialNetworkApp.Accounts
    import SocialNetworkApp.AccountsFixtures

    test "get by email user account" do
      account = create_account_user_fixture()
      assert Accounts.get_account_by_email("test@email.ru") == account
    end
  end
end
