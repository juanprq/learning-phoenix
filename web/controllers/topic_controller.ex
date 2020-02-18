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

  def edit(conn, %{ "id" => topic_id }) do
    topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic)


    render(conn, "edit.html", changeset: changeset, topic: topic)
  end

  def update(conn, %{ "topic" => topic, "id" => topic_id }) do
    old_topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(old_topic, topic)

    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic updated")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset, topic: old_topic)
    end
  end
end
