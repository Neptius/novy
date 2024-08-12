defmodule NovyWeb.LoggedComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div>
      <h1>Welcome, <%= @current_user["preferred_username"] %></h1>
      <p>Here's your user info:</p>
      <pre><%= inspect(@current_user) %></pre>
    </div>
    """
  end
end
