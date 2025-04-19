defmodule IoriWeb.PageController do
  use IoriWeb, :controller

  def index(conn, _params) do
    case extract_site(conn) do
      {:ok, site} ->
        conn
        |> put_resp_content_type("text/html")
        |> send_file(200, site_path(site))

      :error ->
        send_resp(conn, 404, "Site not found")
    end
  end

  defp extract_site(conn) do
    case conn.path_info do
      [site | _] -> {:ok, site}
      # For root path
      [] -> {:ok, "home"}
    end
  rescue
    _ -> :error
  end

  defp site_path(site) do
    # Use the source directory directly in development
    if Mix.env() == :dev do
      Path.expand("priv/static/sites/#{String.downcase(site)}/index.html", File.cwd!())
    else
      Application.app_dir(:iori, Path.join(["priv/static/sites", site, "index.html"]))
    end
  end
end
