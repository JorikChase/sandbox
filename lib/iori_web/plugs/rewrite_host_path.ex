# lib/iori_web/plugs/rewrite_host_path.ex
defmodule IoriWeb.Plugs.RewriteHostPath do
  def init(opts), do: opts

  def call(conn, _opts) do
    # Use subdomain or first path segment as site identifier
    site =
      case conn.host do
        "localhost" -> conn.path_info |> List.first() |> String.downcase()
        host -> host |> String.split(".") |> List.first() |> String.downcase()
      end

    %{conn | path_info: [site | conn.path_info]}
  end
end
