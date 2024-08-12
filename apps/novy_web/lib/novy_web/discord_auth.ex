defmodule NovyWeb.DiscordAuth do

  import Plug.Conn
  import Phoenix.Controller

  alias Assent.{Config, Strategy.Discord}

  # http://localhost:4000/auth/discord
  def request(conn) do
    Application.get_env(:assent, :discord)
    |> Discord.authorize_url()
    |> case do
      {:ok, %{url: url, session_params: session_params}} ->
        # Session params (used for OAuth 2.0 and OIDC strategies) will be
        # retrieved when user returns for the callback phase
        conn = put_session(conn, :session_params, session_params)

        # Redirect end-user to Discord to authorize access to their account
        conn
        |> put_resp_header("location", url)
        |> send_resp(302, "")

      {:error, error} ->
        # Something went wrong generating the request authorization url
        conn
        |> send_resp(500, "Internal Server Error")
    end
  end

  # http://localhost:4000/auth/discord/callback
  def callback(conn) do
    # End-user will return to the callback URL with params attached to the
    # request. These must be passed on to the strategy. In this example we only
    # expect GET query params, but the provider could also return the user with
    # a POST request where the params is in the POST body.
    %{params: params} = fetch_query_params(conn)

    # The session params (used for OAuth 2.0 and OIDC strategies) stored in the
    # request phase will be used in the callback phase
    session_params = get_session(conn, :session_params)

    Application.get_env(:assent, :discord)
    # Session params should be added to the config so the strategy can use them
    |> Config.put(:session_params, session_params)
    |> Discord.callback(params)
    |> case do
      {:ok, %{user: user, token: token}} ->
        # Authorization succesful
        conn
        |> put_session(:current_user, user)
        |> put_session(:current_token, token)
        |> redirect(to: "/")

      {:error, error} ->
        # Authorizaiton failed
        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(500, inspect(error, pretty: true))
    end
  end

  def fetch_discord_user(conn, _opts) do
    with user when is_map(user) <- get_session(conn, :current_user) do
      assign(conn, :current_user, user)
    else
      _ -> conn
    end
  end

  def log_out_user(conn) do
    user_token = get_session(conn, :user_token)
    user_token && Accounts.delete_user_session_token(user_token)

    if live_socket_id = get_session(conn, :live_socket_id) do
      NovyWeb.Endpoint.broadcast(live_socket_id, "disconnect", %{})
    end

    conn
    |> renew_session()
    |> redirect(to: "/")
  end


  defp renew_session(conn) do
    delete_csrf_token()

    conn
    |> configure_session(renew: true)
    |> clear_session()
  end

  def on_mount(:mount_current_user, _params, session, socket) do
    {:cont, mount_current_user(socket, session)}
  end

  defp mount_current_user(socket, session) do
    Phoenix.Component.assign_new(socket, :current_user, fn ->
      if user = session["current_user"] do
        user
      end
    end)
  end
end
