defmodule Gruf do
  alias Gruf.Server

  def start() do
    Server.start_link()
  end

  def add_flow(pid, initial_vertex) do
    GenServer.call(pid, {:add_flow, initial_vertex})
  end

  def add_vertex(pid, vertex, flow_id) do
    GenServer.call(pid, {:add_vertex, vertex, flow_id})
  end

  def list_flow_ids(pid) do
    GenServer.call(pid, :list_flow_ids)
  end
end
