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
end
