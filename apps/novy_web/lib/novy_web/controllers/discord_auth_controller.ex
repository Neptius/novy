defmodule NovyWeb.DiscordAuthController do
  use NovyWeb, :controller
  alias NovyWeb.DiscordAuth

  def request(conn, _params) do
    DiscordAuth.request(conn)
  end

  def callback(conn, _params) do
    DiscordAuth.callback(conn)
  end
end
