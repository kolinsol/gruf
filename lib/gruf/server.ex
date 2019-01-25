defmodule Gruf.Server do
  use GenServer

  alias Gruf.State
  alias Gruf.Util

  def start_link() do
    GenServer.start_link(__MODULE__, [])
  end

  def init([]) do
    {:ok, %State{}}
  end

  def handle_call(:list_flow_ids, _from, state) do
    reply = Util.list_flow_ids(state)
    {:reply, reply, state}
  end

  def handle_cast({:add_flow, initial_vertex}, state) do
    new_state = Util.add_flow(initial_vertex, state)
    {:noreply, new_state}
  end
end
