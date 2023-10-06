defmodule SocialNetworkApp.AccountsTest do
  alias SocialNetworkApp.Users
  use SocialNetworkApp.DataCase

  alias SocialNetworkApp.Products

  describe "accounts" do
    alias SocialNetworkApp.Accounts
    import SocialNetworkApp.AccountsFixtures

    test "get by email user account" do
      user = create_account_user_fixture()
      assert Users.get_user_by_id(user.account_id)
    end
  end
end
