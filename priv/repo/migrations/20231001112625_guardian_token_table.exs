defmodule SocialNetworkApp.Repo.Migrations.GuardianTokenTable do
  use Ecto.Migration

  def change do
    create table(:guardian_token, primary_key: false) do
      add(:jti, :string, primary_key: true)
      add(:typ, :string)
      add(:aud, :string)
      add(:iss, :string)
      add(:sub, :string)
      add(:exp, :bigint)
      add(:jwt, :text)
      add(:claims, :map)

      timestamps()
    end
  end
end
