defmodule SocialNetworkApp.Pictures.Raiting do
  use Ecto.Schema
  import Ecto.Changeset

  schema "raitings" do
    belongs_to :user, SocialNetworkApp.Users.User, type: :binary_id
    belongs_to :picture, SocialNetworkApp.Pictures.Picture, type: :integer
    field :raiting, :float

    timestamps()
  end

  def changeset(raiting, attrs) do
    raiting
    |> cast(attrs, [:user_id, :picture_id, :raiting])
    |> validate_required([:user_id, :picture_id, :raiting])
    |> validate_float_round()
  end

  defp validate_float_round(changeset, field \\ :raiting) when is_atom(field) do
    param = get_field(changeset, field)
    unless is_float(param) do
      add_error(changeset, :raiting, "need float number")
    else
      changeset =
        param
        |> to_string()
        |> Decimal.new()
        |> Decimal.round(1)
        |> Decimal.to_float()
        |> add_num_in_changeset(changeset)
      validate_num_raiting(changeset)
    end
  end

  defp add_num_in_changeset(num, changeset) do
    change(changeset, raiting: num)
  end

  defp validate_num_raiting(changeset) do
    raiting = get_field(changeset, :raiting)
    if 0 < raiting && raiting < 5.91 do
      changeset
    else
      add_error(changeset, :raiting, " from 0.1 to 5.9 raiting interval")
    end
  end
end
