defmodule Gruf.State.Router do
  def add_route(router, vertex_id, flow_id, vertex_index) do
    Map.put(router, vertex_id, {flow_id, vertex_index})
  end

  def get_route(router, vertex_id) do
    Map.get(router, vertex_id)
  end
end
