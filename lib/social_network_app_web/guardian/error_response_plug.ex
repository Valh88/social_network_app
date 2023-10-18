defmodule SocialNetworkAppWeb.Guardian.ErrorResponsePlug do
  defmodule Unauthorized do
    defexception [message: "Unauthorized", plug_status: 401]
  end
  defmodule Forbidden do
    defexception [message: "no  permissions", plug_status: 403]
  end

  defmodule NotFound do
    defexception [message: "content not found", plug_status: 404]
  end
end
