defmodule Gruf do
  alias Gruf.Server

  def create(name) do
    Gruf.DynamicSupervisor.create(name)
  end

  def remove(name) do
    Gruf.DynamicSupervisor.remove(name)
  end

  # Gruf API
  #
  # add_flow
  # add_vertex
  # get_vertex
  # split_flow
  # branch_flow
  # link_vertex

  # TODO: consider reimplementing this as a call to add_vertex
  def add_flow(name, vertex_data) do
    Server.internal_call(name, {:add_flow, vertex_data})
  end

  def add_vertex(name, vertex_data, flow_id) do
    Server.internal_call(name, {:add_vertex, vertex_data, flow_id})
  end

  def get_vertex(name, vertex_id) do
    Server.internal_call(name, {:get_vertex, vertex_id})
  end
end
