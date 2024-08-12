defmodule NovyWeb.LoggedComponent do
  use NovyWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>
      <%= if @current_user do %>
        <div class="flex items-center gap-2">
          <p class="capitalize">Welcome, <%= @current_user["preferred_username"] %></p>
          <img class="rounded-full w-10" src={@current_user["picture"]} />
        </div>

        <.link
          href={~p"/auth/discord/logout"}
          method="delete"
          class="bg-red-500 hover:bg-red-700 text-white py-2 px-4 rounded-lg"
        >
          Déconnexion
        </.link>
      <% else %>
        <.link
          href={~p"/auth/discord"}
          class="bg-blue-500 hover:bg-blue-700 text-white py-2 px-4 rounded-lg"
        >
          Connexion via Discord
        </.link>
      <% end %>
    </div>
    """
  end
end
