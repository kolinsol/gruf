defmodule Gruf.Util do
  alias Gruf.State

  def add_flow(initial_vertex, %State{data: data, router: router}) do
    flow_id = gen_flow_id()
    vertex_id = gen_vertex_id()

    new_data = Map.put(
      data, flow_id, :array.set(
        0, add_id(vertex_id, initial_vertex), :array.new()
      )
    )

    new_router = router
      |> Map.put(flow_id, 0)
      |> Map.put(vertex_id, {flow_id, 0})

    reply = {:ok, %{flow: flow_id, vertex: vertex_id, vertex_index: 0}}
    {reply, %State{data: new_data, router: new_router}}
  end

  def add_vertex(vertex, flow_id, %State{data: data, router: router} = state) do
    with {:flow_data, {:ok, flow_data}} <- {:flow_data, Map.fetch(data, flow_id)},
         {:last_flow_index, {:ok, last_flow_index}} <- {:last_flow_index, Map.fetch(router, flow_id)}
    do
      vertex_id = gen_vertex_id()
      vertex_index = last_flow_index + 1

      new_flow_data = :array.set(vertex_index, add_id(vertex_id, vertex), flow_data)

      new_data = Map.put(data, flow_id, new_flow_data)

      new_router = router
        |> Map.put(flow_id, vertex_index)
        |> Map.put(vertex_id, {flow_id, vertex_index})

      reply = {:ok, %{flow: flow_id, vertex: vertex_id, vertex_index: vertex_index}}
      {reply, %State{data: new_data, router: new_router}}
    else
      # TODO: return reasonable errors
      _ -> {:error, state}
    end
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
