defmodule SocialNetworkApp.Users do
  import Ecto.Query, warn: false
  alias SocialNetworkApp.Users.Subscribe
  alias SocialNetworkApp.Accounts.Account
  alias SocialNetworkApp.Repo
  alias SocialNetworkApp.Users.User
  alias SocialNetworkApp.Pictures.Picture

  @spec create_user(%Account{}, %{account_id: binary()} | %{}) :: {:ok, %User{}}
  def create_user(account, attrs \\ %{}) do
    account
    |> Ecto.build_assoc(:user)
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @spec add_new_picture_by_user(%User{}, %{name: String.t(), path: String.t()}) :: {:ok, %Picture{}}
  def add_new_picture_by_user(%User{} = account_user, params) do
    account_user
    |> User.changeset(params)
    |> Repo.insert()
  end

  @spec get_user_by_id(binary()) :: %User{} | nil
  def get_user_by_id(account_id) do
    User
    |> where(account_id: ^account_id)
    |> Repo.one()
  end

  @spec subscribe_to_user(%{subscriber_id: binary(), on_sub_id: binary()}) :: {:ok, struct()}
  def subscribe_to_user(params) do
    %Subscribe{}
    |> Subscribe.changeset(params)
    |> Repo.insert()
  end
end
