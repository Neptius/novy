defmodule NovyWeb.HomeLive.Index do
  use NovyWeb, :live_view
  use NovyNative, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket, layout: {NovyWeb.Layouts, :blank}}
  end
end
