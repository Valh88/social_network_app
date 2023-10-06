defmodule SocialNetworkApp.Accounts do
  @doc false
  import Ecto.Query

  alias SocialNetworkApp.Users
  alias SocialNetworkApp.Accounts.Account
  alias SocialNetworkApp.Repo

  def list_accounts do
    Repo.all(Account)
  end

  @spec create_account(
          :invalid
          | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) ::
          {:ok,
           %SocialNetworkApp.Users.User{
             __meta__: any,
             account: any,
             account_id: any,
             id: any,
             inserted_at: any,
             pictures: any,
             updated_at: any
           }}
  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
    |> add_user()
  end

  @spec get_account_by_email(String.t()) :: %Account{} | nil
  def get_account_by_email(email) do
    Account
    |> where(email: ^email)
    |> Repo.one()
  end

  defp add_user({:ok, user}) do
    user
    |> Users.create_user(%{account_id: user.id})
  end
end
