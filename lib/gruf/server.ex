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

  def handle_call({:add_flow, initial_vertex}, _from, state) do
    {reply, new_state} = Util.add_flow(initial_vertex, state)
    {:reply, reply, new_state}
  end

  def handle_call({:add_vertex, vertex, flow_id}, _from, state) do
    {reply, new_state} = Util.add_vertex(vertex, flow_id, state)
    {:reply, reply, new_state}
  end

  def handle_call({:get_vertex, vertex_id}, _from, state) do
    reply = Util.get_vertex(vertex_id, state)
    {:reply, reply, state}
  end
end
