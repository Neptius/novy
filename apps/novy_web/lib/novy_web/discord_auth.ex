defmodule NovyWeb.DiscordAuth do
  import Plug.Conn

  alias Assent.{Config, Strategy.Discord}
  alias Novy.Accounts
  alias Novy.Accounts.User

  # http://localhost:4000/auth/discord
  def request(conn) do
    Application.get_env(:assent, :discord)
    |> Discord.authorize_url()
    |> IO.inspect(label: "authorize_url")
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
        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(
          500,
          "Something went wrong generating the request authorization url: #{inspect(error)}"
        )
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
    |> IO.inspect(label: "callback params")
    |> case do
      {:ok, %{user: user, token: token}} ->
        # Authorization succesful
        IO.inspect({user, token}, label: "user and token")

        user_record = Accounts.get_or_create_user_from_oauth("discord", user)

        conn
        |> NovyWeb.UserAuth.log_in_user(user_record)

      {:error, error} ->
        # Authorizaiton failed
        IO.inspect(error, label: "error")

        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(500, inspect(error, pretty: true))
    end
  end

  def fetch_discord_user(conn, _opts) do
    with user when is_map(user) <- get_session(conn, :discord_user) do
      assign(conn, :current_user, %User{email: user["email"]})
    else
      _ -> conn
    end
  end

  def on_mount(:mount_current_user, _params, session, socket) do
    {:cont, mount_current_user(socket, session)}
  end

  defp mount_current_user(socket, session) do
    Phoenix.Component.assign_new(socket, :current_user, fn ->
      if user = session["discord_user"] do
        %User{email: user["email"]}
      end
    end)
  end
end
