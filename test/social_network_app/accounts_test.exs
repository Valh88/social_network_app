defmodule SocialNetworkApp.AccountsTest do
  alias SocialNetworkApp.Accounts
  alias SocialNetworkApp.Accounts.Account
  alias SocialNetworkApp.Users
  use SocialNetworkApp.DataCase

  setup_all do
    %{
      picture: %{name: "Name", path: "test/media/Name"},
      user_params_one: %{email: "test@email.ru", password_hash: "test_password"},
      user_params_two: %{email: "test2@email.ru", password_hash: "test2_password"},
    }
  end

  describe "accounts" do
    import SocialNetworkApp.AccountsFixtures

    test "get by email user account", context do
      account = create_account_user_fixture(context.user_params_one)
      assert Accounts.get_account_by_id(account.id)
    end

    test "subsciribe users", context do
      user_1 = create_account_and_user(context.user_params_one)
      user_2 = create_account_and_user(context.user_params_two)
      params = %{subscriber_id: user_1.id, on_sub_id: user_2.id}
      {:ok, subscribe} = SocialNetworkApp.Users.subscribe_to_user(params)
      assert subscribe.subscriber_id == user_1.id
      assert subscribe.on_sub_id == user_2.id
    end
  end
end
