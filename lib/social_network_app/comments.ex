defmodule SocialNetworkApp.Comments do
  alias SocialNetworkApp.Repo
  alias SocialNetworkApp.Comments.Comment

  def create_comment(attrs) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end
end
