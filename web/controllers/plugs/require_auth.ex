defmodule Discuss.Plugs.RequireAuth do
  import Plug.Conn
  import Phoenix.Controller

  alias Discuss.Router.Helpers

  def init(_params) do
  end

  def call(%{ assigns: %{ user: nil } } = conn, _params) do
    conn
    |> put_flash(:info, "you must be logged in")
    |> redirect(to: Helpers.topic_path(conn, :index))
    |> halt()
  end
  def call(conn, _param), do: conn
end
