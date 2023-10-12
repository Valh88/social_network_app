defmodule SocialNetworkApp.AccountsFixtures do
  @moduledoc false


  def create_account_user_fixture(params) do
    {:ok, account} =
      SocialNetworkApp.Accounts.create_account(params)
    account
  end

  @spec create_picture_fixture(atom | %{:id => binary, optional(any) => any}, %{
          name: binary,
          path: binary
        }) :: {:ok, struct}
  def create_picture_fixture(user, params) do
    SocialNetworkApp.Pictures.save_all_to_picture(user, params)
  end

  def create_account_and_user(params) do
    with {:ok, account} <- SocialNetworkApp.Accounts.create_account(params),
         {:ok, user} <- SocialNetworkApp.Users.create_user(account, %{account_id: account.id}) do
      user
    end
  end
end
