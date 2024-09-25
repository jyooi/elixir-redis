defmodule CodecraftersRedisElixir.Application do
  use Application
  alias CodecraftersRedisElixir.Server

  def start(_type, _args) do
    children = [{Task, fn -> Server.accept() end}]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
