defmodule Gruf do

  def create(name) do
    Gruf.DynamicSupervisor.create(name)
  end

  def remove(pid) do
    Gruf.DynamicSupervisor.remove(pid)
  end

  def add_flow(pid, vertex_data) do
    GenServer.call(pid, {:add_flow, vertex_data})
  end

  def add_vertex(pid, vertex_data, flow_id) do
    GenServer.call(pid, {:add_vertex, vertex_data, flow_id})
  end

  def get_vertex(pid, vertex_id) do
    GenServer.call(pid, {:get_vertex, vertex_id})
  end
end
