defmodule SocialNetworkApp.Pictures do
  @moduledoc false

  import Ecto.Query
  alias SocialNetworkApp.Pictures.{PictureUserAssoc, Picture, Raiting}
  alias SocialNetworkApp.Repo

  @spec save_picture(%{name: String.t(), path: String.t()}) :: {:ok, %Picture{}}
  def save_picture(attrs) do
    %Picture{}
    |> Picture.changeset(attrs)
    |> Repo.insert()
  end

  @spec save_assoc_picture_to_user(%{user_id: binary(), picture_id: integer()}, %PictureUserAssoc{}) :: {:ok, struct()}
  def save_assoc_picture_to_user(params, assoc \\ %PictureUserAssoc{}) do
    assoc
    |> PictureUserAssoc.changeset(params)
    |> Repo.insert()
  end

  def save_all_to_picture(user, params) do
    {:ok, picture} = save_picture(params)
    save_assoc_picture_to_user(%{user_id: user.id, picture_id: picture.id})
  end

  def get_picture_by_id(picture_id) do
    Picture
    |> where(id: ^picture_id)
    |> Repo.one()
  end

  @spec add_raiting_from_user_to_picture(struct(), struct(), float()) :: {:ok, struct()}
  def add_raiting_from_user_to_picture(picture, user, raiting) do
    params = %{picture_id: picture.id, user_id: user.id, raiting: raiting}
    %Raiting{}
    |> Raiting.changeset(params)
    |> Repo.insert()
  end
end
