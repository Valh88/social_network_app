defmodule SocialNetworkAppWeb.RaitingJSON do

  def raiting(%{raiting: raiting}) do
    %{
      id: raiting.id,
      raiting: raiting.raiting
    }
  end
end
