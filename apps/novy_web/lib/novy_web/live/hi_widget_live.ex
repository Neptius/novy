defmodule NovyWeb.HiWidgetLive do
  use NovyWeb, :live_view
  on_mount {NovyWeb.DiscordAuth, :mount_current_user}

  def render(assigns) do
    if assigns[:current_user] do
      ~H"""
      <div>👋 Hi, <%= @current_user["preferred_username"] %></div>
      """
    else
      ~H"""
      <div>🤔 Do I know you?</div>
      """
    end
  end

  def mount(_params, session, socket) do
    {:ok, assign(socket, current_user: session["current_user"])}
  end
end
