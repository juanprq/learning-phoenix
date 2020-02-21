defmodule Discuss.TopicController do
  use Discuss.Web, :controller

  alias Discuss.Topic

  plug Discuss.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]
  plug :check_topic_owner when action in [:edit, :update, :delete]

  def index(conn, _params) do
    topics = Repo.all(Topic)

    render(conn, "index.html", topics: topics)
  end

  def show(conn, %{"id" => topic_id}) do
    topic = Repo.get(Topic, topic_id)

    render(conn, "show.html", topic: topic)
  end

  def new(conn, _params) do
    changeset =
      %Topic{}
      |> Topic.changeset(%{})

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"topic" => topic}) do
    changeset = conn.assigns.user
                |> build_assoc(:topics)
                |> Topic.changeset(topic)

    case Repo.insert(changeset) do
      {:ok, _topic} ->
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

  def delete(conn, %{"id" => topic_id}) do
    topic = Repo.get(Topic, topic_id)
    case Repo.delete(topic) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Topic deleted")
        |> redirect(to: topic_path(conn, :index))
      {:error, _} ->
        conn
        |> put_flash(:error, "An error ocurred trying to delete the topic")
        |> redirect(to: topic_path(conn, :index))
    end
  end

  defp check_topic_owner(%{params: %{"id" => topic_id}, assigns: %{ user: %{ id: user_id } }} = conn, _params) do
    case Repo.get(Topic, topic_id) do
      %{user_id: ^user_id} ->
        conn
      _ ->
        conn
        |> put_flash(:error, "You cannot edit the topic")
        |> redirect(to: topic_path(conn, :index))
    end
  end
end
