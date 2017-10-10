defmodule ChatServer.Command do
  @doc ~S"""
  Parses the given `line` into a command.

  ## Examples

    iex> ChatServer.Command.parse "CREATE message\r\n"
    {:ok, {:create, "shopping"}}

    iex> KVServer.Command.parse "CREATE  message  \r\n"
    {:ok, {:create, "shopping"}}

    iex> KVServer.Command.parse "PUT message milk 1\r\n"
    {:ok, {:put, "shopping", "milk", "1"}}

    iex> KVServer.Command.parse "GET message milk\r\n"
    {:ok, {:get, "shopping", "milk"}}

    iex> KVServer.Command.parse "DELETE message eggs\r\n"
    {:ok, {:delete, "shopping", "eggs"}}

Unknown commands or commands with the wrong number of
arguments return an error:

    iex> KVServer.Command.parse "UNKNOWN message eggs\r\n"
    {:error, :unknown_command}

    iex> KVServer.Command.parse "GET message\r\n"
    {:error, :unknown_command}
  """
  def parse(line) do
    case String.split(line) do
      ["CREATE", bucket] -> {:ok, {:create, bucket}}
      ["GET", bucket, key] -> {:ok, {:get, bucket, key}}
      ["PUT", bucket, key, value] -> {:ok, {:put, bucket, key, value}}
      ["DELETE", bucket, key] -> {:ok, {:delete, bucket, key}}
      _ -> {:error, :unknown_command}
    end
  end

  def run(command) do
    {:ok, "OK\r\n"}
  end
end
