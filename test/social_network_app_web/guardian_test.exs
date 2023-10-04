defmodule SocialNetworkAppWeb.GuardianTest do
  use SocialNetworkApp.DataCase

  alias SocialNetworkApp.Accounts
  alias SocialNetworkAppWeb.Guardian.GuardianAuth
  import SocialNetworkApp.AccountsFixtures
  test "test auth token" do
    account = create_account_user_fixture()
    {:ok, account_test1, token} = GuardianAuth.authenticate("test@email.ru", "test_password")
    assert account == account_test1
    assert token

    {:ok, claims} = GuardianAuth.decode_and_verify(token)
    {:ok, account_test2} = GuardianAuth.resource_from_claims(claims)
    assert account == account_test2
  end

  test "test auth if user not exists" do
    data = GuardianAuth.authenticate("test@email.ru", "test_password")
    assert data == {:error, :not_found}
  end
end
