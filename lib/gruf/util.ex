defmodule Gruf.Util do
  alias Gruf.State

  def add_flow(initial_vertex, %State{data: data, router: router}) do
    flow_id = gen_flow_id()
    vertex_id = gen_vertex_id()

    new_data = Map.put(
      data, flow_id, [add_id(vertex_id, initial_vertex)]
    )

    new_router = router
      |> Map.put(flow_id, 0)
      |> Map.put(vertex_id, {flow_id, 0})

    %State{data: new_data, router: new_router}
  end

  def list_flow_ids(%State{data: data}) do
    {:ok, Map.keys(data)}
  end

  defp gen_vertex_id() do
    ulid = Ulid.generate()
    "vertex:#{ulid}"
  end

  defp add_id(id, entity) do
    Map.put(entity, :id, id)
  end
  
  defp gen_flow_id() do
    ulid = Ulid.generate()
    "flow:#{ulid}"
  end
end
