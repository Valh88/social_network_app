defmodule SocialNetworkApp.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias SocialNetworkApp.Pictures.Picture
  schema "comments" do
    belongs_to :picture, Picture
    field :text, :string

    timestamps()
  end

  @spec changeset(struct(), map()) :: Ecto.Changeset.t()
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:picture_id, :text])
    |> validate_required([:picture_id, :text])
  end
end
