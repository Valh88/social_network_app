defmodule SocialNetworkApp.Pictures.PictureUserAssoc do
  use Ecto.Schema
  import Ecto.Changeset

  @optional_fields [:id, :inserted_at, :updated_at]
  # @primary_key {:id, :binary_id, autogenerate: true}
  # @foreign_key_type :binary_id
  schema "pictures_users" do
    belongs_to :user, SocialNetworkApp.Users.User, type: :binary_id
    belongs_to :picture, SocialNetworkApp.Pictures.Picture, type: :integer

    timestamps()
  end


  @spec changeset(struct(), map()) :: Ecto.Changeset.t()
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :picture_id])
    |> validate_required([:user_id, :picture_id])
  end
end
