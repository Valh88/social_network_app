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

  @spec get_pick_all([{:limit, number}, {:offset, number()}]) :: list([name: String.t(), path: String.t(), publisher: binary()])
  def get_pick_all(limit: limit_on_page, offset: num_page_offset) do
    offset = max((num_page_offset - 1) * limit_on_page, 0)

    query = from p in Picture,
      order_by: [desc: p.inserted_at],
      limit: ^limit_on_page,
      offset: ^offset,
      # join: r in Raiting,
      # on: r.picture_id == p.id,
      # group_by: [p.id],
      join: pub in assoc(p, :publisher),
      select: [
        name: p.name,
        path: p.path,
        publisher: pub.id
      ]
      # preload: :publisher
    Repo.all(query)
  end

  @spec count_pictures_by_user_id(binary()) :: integer()
  def count_pictures_by_user_id(user_id) do
    query = from ap in PictureUserAssoc,
      where: ap.user_id == ^user_id,
      # join: u in User, on: u.id == ap.user_id,
      # join: p in Picture, on: p.id == ap.picture_id,
      # group_by: [ap.picture_id],
      select: count(ap)
    Repo.one(query)
  end
end
