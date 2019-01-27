defmodule Gruf.Application do
  use Application

  def start(_type, []) do
    {:ok, _pid} = Gruf.Supervisor.start_link([])
  end
end
