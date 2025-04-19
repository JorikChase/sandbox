defmodule IoriWeb.PageController do
  use IoriWeb, :controller

  def index(conn, _params) do
    conn
    |> put_root_layout(false)
    |> put_resp_content_type("text/html")
    |> send_file(200, site_path(conn))
  rescue
    _ -> send_resp(conn, 404, "Site not found")
  end

  defp site_path(conn) do
    [site | _] = conn.path_info
    Application.app_dir(:iori, Path.join(["priv/sites", site, "index.html"]))
  end
end
