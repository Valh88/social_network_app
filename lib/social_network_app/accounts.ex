defmodule SocialNetworkApp.Accounts do
  @doc false
  import Ecto.Query
  alias SocialNetworkApp.Accounts.Account
  alias SocialNetworkApp.Repo

  def list_accounts do
    Repo.all(Account)
  end

  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  @spec get_account_by_email(String.t()) :: %Account{} | nil
  def get_account_by_email(email) do
    Account
    |> where(email: ^email)
    |> Repo.one()
  end
end
