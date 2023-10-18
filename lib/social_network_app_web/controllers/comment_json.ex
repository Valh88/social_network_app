defmodule SocialNetworkAppWeb.CommentJSON do
  def comment(%{comment: comment}) do
    %{
      id: comment.id,
      user_id: comment.user_id,
      text: comment.text,
      inserted_at: comment.inserted_at,
      updated_at: comment.updated_at,
    }
  end

  def comments(%{comments: comments}) do
    %{data: for(comment <- comments, do: comment(%{comment: comment}))}
  end
end
