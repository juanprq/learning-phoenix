defmodule Discuss.PageController do
  use Discuss.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def test(conn, _params) do
    render conn, "test.html"
  end
end
