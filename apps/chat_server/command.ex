defmodule ChatServer.Command do
  @doc -S"""
  Parses the given `line` into a command.

  ## Examples

    iex> ChatServer.Command.parse "CREATE message\r\n"
    {:ok, {:create, "message"}}

  """
  def parse(_line) do
    :not_implemented
  end
end
