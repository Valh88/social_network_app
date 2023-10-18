defmodule SocialNetworkApp.Comments do
  import Ecto.Query
  alias SocialNetworkApp.Repo
  alias SocialNetworkApp.Comments.Comment

  def create_comment(attrs) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  @spec count_comment_by_user_id(binary()) :: integer()
  def count_comment_by_user_id(user_id) do
    query = from c in Comment,
      where: c.user_id == ^user_id,
      select: count(c)
    Repo.one(query)
  end

  def get_comments(picture_id, [limit: limit_on_page, offset: num_page_offset]) do
    IO.inspect([limit: limit_on_page, offset: num_page_offset])
    offset = max((num_page_offset - 1) * limit_on_page, 0)
    query = from c in Comment,
      where: c.picture_id == ^picture_id,
      limit: ^limit_on_page,
      offset: ^offset,
      select: c
    Repo.all(query)
  end

  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  

  def get_comment_by_id(comment_id) do
    query = from c in Comment,
    where: c.id == ^comment_id
    Repo.one(query)
  end
end
