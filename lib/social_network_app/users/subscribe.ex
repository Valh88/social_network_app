defmodule SocialNetworkApp.Users.Subscribe do
  use Ecto.Schema
  import Ecto.Changeset
  alias SocialNetworkApp.Users.User

  schema "subscriptions" do
    belongs_to :subscriber, User, type: :binary_id
    belongs_to :on_sub, User, type: :binary_id

    timestamps()
  end

  @spec changeset(struct(), map()) :: Ecto.Changeset.t()
  def changeset(subscripe, params) do
    subscripe
    |> cast(params, [:subscriber_id, :on_sub_id])
    |> validate_required([:subscriber_id, :on_sub_id])
  end
end
