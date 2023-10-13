defmodule SocialNetworkAppWeb.Guardian.ErrorResponsePlug.Unauthorized do
  defexception [message: "Unauthorized", plug_status: 401]
end
