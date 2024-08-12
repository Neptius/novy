defmodule NovyWeb.LoggedComponent do
  use NovyWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>
      <%= if @connected do %>
        <div class="flex items-center gap-2">
          <p class="capitalize">Welcome, <%= @current_user["preferred_username"] %></p>
          <img class="rounded-full w-10" src={@current_user["picture"]} />
        </div>
      <% else %>
        <a href="/auth/discord" class="bg-blue-500 hover:bg-blue-700 text-white py-2 px-4 rounded-lg">
          Connexion via Discord
        </a>
      <% end %>
    </div>
    """
  end
end
