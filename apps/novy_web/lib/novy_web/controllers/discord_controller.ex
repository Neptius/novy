defmodule NovyWeb.DiscordController do
  use NovyWeb, :controller

  alias NovyWeb.DiscordAuth

  def request(conn, _params) do
    DiscordAuth.request(conn)
  end

  def callback(conn, _params) do
    DiscordAuth.callback(conn)
  end

  def delete(conn, _params) do
    DiscordAuth.logout(conn)
  end
end
