defmodule Discuss.TopicController do
  use Discuss.Web, :controller

  alias Discuss.Topic

  def new(conn, _params) do
    changeset =
      %Topic{}
      |> Topic.changeset(%{})

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"topic" => topic}) do
    IO.inspect(topic)
    render(conn, "new.html")
  end
end
