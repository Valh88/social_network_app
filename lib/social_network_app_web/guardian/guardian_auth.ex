defmodule SocialNetworkAppWeb.Guardian.GuardianAuth do
  alias SocialNetworkApp.Accounts
  alias SocialNetworkApp.Users
  use Guardian, otp_app: :social_network_app

  def subject_for_token(account, _claims) do
    sub = to_string(account.id)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :no_id_provided}
  end

  def resource_from_claims(%{"sub" => account_id}) do
    case Users.get_user_by_id(account_id) do
      nil -> {:error, :not_found}
      account -> {:ok, account}
    end
  end

  def resource_from_claims(_claims) do
    {:error, :no_id_provided}
  end

  @spec authenticate(binary, binary) :: {:error, :not_found | :unauthorized} | {:ok, struct(), binary}
  def authenticate(email, password) do
    case Accounts.get_account_by_email(email) do
      nil ->
        {:error, :not_found}
      account ->
        case check_password(password, account.password_hash) do
          true -> create_token(account, :access)
          false -> {:error, :unauthorized}
        end
    end
  end

  defp check_password(password, password_hash) do
    Argon2.verify_pass(password, password_hash)
  end

  @spec create_token(any, :access | :admin | :reset) :: {:ok, any, binary}
  def create_token(account, type) do
    {:ok, token, _claims} = encode_and_sign(account, %{}, token_type(type))
    account = Users.get_user_by_id(account.id)
    {:ok, account, token}
  end

  defp token_type(type) do
    case type do
      :access -> [token_type: "access", ttl: {10, :hour}]
      :reset -> [token_type: "reset", ttl: {15, :minute}]
      :admin -> [token_type: "admin", ttl: {90, :day}]
    end
  end

  def after_encode_and_sign(resource, claims, token, _options) do
    with {:ok, _} <- Guardian.DB.after_encode_and_sign(resource, claims["typ"], claims, token) do
      {:ok, token}
    end
  end

  def on_verify(claims, token, _options) do
    with {:ok, _} <- Guardian.DB.on_verify(claims, token) do
      {:ok, claims}
    end
  end

  def on_revoke(claims, token, _options) do
    with {:ok, _} <- Guardian.DB.on_revoke(claims, token) do
      {:ok, claims}
    end
  end

  def on_refresh({old_token, old_claims}, {new_token, new_claims}, _options) do
    with {:ok, _, _} <- Guardian.DB.on_refresh({old_token, old_claims}, {new_token, new_claims}) do
      {:ok, {old_token, old_claims}, {new_token, new_claims}}
    end
  end
end
