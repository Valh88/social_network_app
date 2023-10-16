defmodule SocialNetworkApp.Users do
  import Ecto.Query, warn: false
  alias SocialNetworkApp.Pictures
  alias SocialNetworkApp.Users.Subscribe
  alias SocialNetworkApp.Accounts.Account
  alias SocialNetworkApp.Repo
  alias SocialNetworkApp.Users.{User, Subscribe}
  alias SocialNetworkApp.Pictures.Picture

  @spec create_user(%Account{}, %{account_id: binary(), role_id: integer()}) :: {:ok, struct()}
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

  @spec get_user_by_account_id(binary()) :: %User{} | nil
  def get_user_by_account_id(account_id) do
    User
    |> where(account_id: ^account_id)
    |> Repo.one()
  end

  def get_user_by_user_id(user_id) do
    User
    |> where(id: ^user_id)
    |> Repo.one()
  end

  @spec subscribe_to_user(%{subscriber_id: binary(), on_sub_id: binary()}) :: {:ok, struct()}
  def subscribe_to_user(params) do
    %Subscribe{}
    |> Subscribe.changeset(params)
    |> Repo.insert()
  end

   @spec unsubscribe_to_user(%{subscriber_id: binary(), on_sub_id: binary()})
   :: {:ok, struct()} | {:error, :not_found}
  def unsubscribe_to_user(params) do
    case get_subsribe(params) do
      nil -> {:error, :not_found}
      sub -> Repo.delete(sub)
    end
  end

  defp get_subsribe(params) do
    %{subscriber_id: user_id, on_sub_id: on_sub_id} = params
    query = from sub in Subscribe,
      where: sub.subscriber_id == ^user_id and sub.on_sub_id == ^on_sub_id,
      select: sub
    Repo.one(query)
  end
  
  def get_all_user_paginate(limit: limit_on_page, offset: num_page_offset) do
    offset = max((num_page_offset - 1) * limit_on_page, 0)

    query = from u in User,
      #    distinct: true
      order_by: [desc: u.inserted_at],
      limit: ^limit_on_page,
      offset: ^offset,
      # join: a in Account,
      # on: a.id == u.account_id,
      # group_by: [u.id],
      join: a in assoc(u, :account),
      # join: p in assoc(u, :pictures)
      # group_by: [u.id],
      select: [
        id: u.id,
        email: a.email,
        inserted: u.inserted_at,
        updated: u.updated_at
      ]
    Repo.all(query)
  end

  @spec subscriber_to_user_count(binary()) :: integer()
  def subscriber_to_user_count(user_id) do
    query = from u in User,
      where: u.id == ^user_id,
      join: sub_to in assoc(u, :subscribe_on),
      group_by: u.id,
      select: count(sub_to)
    case Repo.one(query) do
      nil -> 0
      count -> count
    end
  end

  @spec subscribers_on_user(binary()) :: integer()
  def subscribers_on_user(user_id) do
    query = from sub in Subscribe,
      where: sub.on_sub_id == ^user_id,
      select: count(sub)
    Repo.one(query)
  end

  @spec get_full_user_info(binary()) :: %{
          id: binary(),
          on_sub: integer(),
          pictures_publish: integer(),
          to_sub: integer()
        }
  def get_full_user_info(user_id) do
    %{}
    |> Map.put(:id, user_id)
    |> Map.put(:on_sub, subscriber_to_user_count(user_id))
    |> Map.put(:to_sub, subscribers_on_user(user_id))
    |> Map.put(:pictures_publish, Pictures.count_pictures_by_user_id(user_id))
 end
end
