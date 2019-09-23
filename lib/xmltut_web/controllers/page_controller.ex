defmodule XmltutWeb.PageController do
  use XmltutWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
