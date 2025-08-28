defmodule NovyWeb.PageController do
  use NovyWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
