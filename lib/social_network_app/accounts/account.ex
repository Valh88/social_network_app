defmodule SocialNetworkApp.Accounts.Account do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @optional_fields [:id, :inserted_at, :updated_at]
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :email, :string
    field :password_hash, :string

    timestamps()
  end

  defp fields do
    __MODULE__.__schema__(:fields)
  end

  @spec changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  def changeset(account, attrs) do
    account
    |> cast(attrs, fields())
    |> validate_required(fields() -- @optional_fields)
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 88, message: "max len 88")
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  @spec put_password_hash(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp put_password_hash(
    %Ecto.Changeset{valid?: true, changes: %{password_hash: password}} = changeset
  ) do
    change(changeset, password_hash: Argon2.hash_pwd_salt(password))
  end

  @spec put_password_hash(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp put_password_hash(changeset), do: changeset
end
