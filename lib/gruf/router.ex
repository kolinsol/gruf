defmodule Gruf.Router do
  alias Gruf.Flow

  def add_vertex(router, vertex_id, flow_id) do
    cur_flow_index = get_flow_index(router, flow_id)
    Map.put(router, vertex_id, {flow_id, cur_flow_index})
  end

  def init_flow_index(router, flow_id) do
    Map.put(router, flow_id, 0)
  end

  def get_flow_index(router, flow_id) do
    Map.get(router, flow_id)
  end

  def inc_flow_index(router, flow_id) do
    next_flow_index = Flow.get_next_index(flow_id, router)
    Map.put(router, flow_id, next_flow_index)
  end
end
