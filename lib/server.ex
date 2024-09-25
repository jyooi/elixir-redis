defmodule CodecraftersRedisElixir.Server do
  @port 6379

  def accept() do
    {:ok, socket} =
      :gen_tcp.listen(@port, [:binary, active: false, reuseaddr: true])

    IO.puts("Accepting connections on port #{@port}")
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    serve(client)
    loop_acceptor(socket)
  end

  defp serve(socket) do
    socket
    |> read_line()
    |> (&write_line(&1, socket)).()

    serve(socket)
  end

  defp read_line(socket) do
    case :gen_tcp.recv(socket, 0) do
      {:ok, "*1\r\n$4\r\nPING\r\n"} ->
        "+PONG\r\n"

      {:error, reason} ->
        {:error, reason}

      _ ->
        nil
    end
  end

  defp write_line(line, socket) do
    :gen_tcp.send(socket, line)
  end
end
