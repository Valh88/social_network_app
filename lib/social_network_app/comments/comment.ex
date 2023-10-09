defmodule SocialNetworkApp.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias SocialNetworkApp.Pictures.Picture
  alias SocialNetworkApp.Users.User
  schema "comments" do
    belongs_to :picture, Picture, type: :integer
    belongs_to :user, User, type: :binary_id
    field :text, :string

    timestamps()
  end

  @spec changeset(struct(), map()) :: Ecto.Changeset.t()
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:picture_id, :user_id, :text])
    |> validate_required([:picture_id, :user_id, :text])
  end
end
