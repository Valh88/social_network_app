defmodule SocialNetworkApp.Pictures.Picture do
  use Ecto.Schema
  import Ecto.Changeset

  alias SocialNetworkApp.Users.User
  alias SocialNetworkApp.Pictures.{Raiting, Raiting}

  @optional_fields [:id, :inserted_at, :updated_at]
  # @primary_key {:id, :binary_id, autogenerate: true}
  # @foreign_key_type :binary_id
  schema "pictures" do
    field :name, :string
    field :path, :string
    many_to_many :publisher, User,
      join_through: "pictures_users"
    has_many :comments, SocialNetworkApp.Comments.Comment
    many_to_many :raiting_from_user, User,
      join_through: Raiting

    timestamps()
  end

  defp fields do
    __MODULE__.__schema__(:fields)
  end

  @spec changeset(struct(), map()) :: Ecto.Changeset.t()
  def changeset(picture, attrs) do
    picture
    |> cast(attrs, fields())
    |> validate_required(fields() -- @optional_fields)
  end

end
