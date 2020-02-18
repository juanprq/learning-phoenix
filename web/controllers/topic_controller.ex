defmodule Discuss.TopicController do
  use Discuss.Web, :controller

  alias Discuss.Topic

  def index(conn, _params) do
    topics = Repo.all(Topic)

    render(conn, "index.html", topics: topics)
  end

  def new(conn, _params) do
    changeset =
      %Topic{}
      |> Topic.changeset(%{})

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"topic" => topic}) do
    changeset = Discuss.Topic.changeset(%Topic{}, topic)
    case Repo.insert(changeset) do
      {:ok, topic} ->
        conn
        |> put_flash(:info, "Topic created")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} -> render(conn, "new.html", changeset: changeset)
    end
  end
end
