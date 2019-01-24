defmodule Gruf do
  use GenServer

  alias Gruf.State
  alias Gruf.Util

  def start_link() do
    GenServer.start_link(__MODULE__, [])
  end

  def init([]) do
    {:ok, %State{}}
  end
end
