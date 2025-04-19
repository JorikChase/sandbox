defmodule IoriWeb.Plugs.RewriteHostPath do
#  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    # Prepend host to path_info and sanitize
    host = conn.host |> String.replace(".", "_")
    %{conn | path_info: [host | conn.path_info]}
  end
end
