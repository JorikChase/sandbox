defmodule IoriWeb.PageController do
  use IoriWeb, :controller

  def index(conn, _params) do
  send_resp(conn, 404, "site not found")
  end
end
