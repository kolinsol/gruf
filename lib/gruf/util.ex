defmodule Gruf.Util do
  alias Gruf.State
  alias Gruf.State.Router

  alias Gruf.Model.Flow
  alias Gruf.Model.Vertex

  def add_flow(vertex_data, %State{data: data, router: router}) do
    vertex = Vertex.new(vertex_data)
    flow = Flow.new(vertex)

    new_data = Map.put(data, flow.id, flow)

    new_router = router
      |> Router.init_flow_index(flow.id)
      |> Router.add_vertex(vertex.id, flow.id)

    reply = {:ok, %{flow: flow.id, vertex: vertex.id, vertex_index: 0}}
    {reply, %State{data: new_data, router: new_router}}
  end

  def add_vertex(vertex_data, flow_id, %State{data: data, router: router} = state) do
    with {:flow, {:ok, flow}} <- {:flow, Flow.get_by_id(flow_id, data)}
    do
      vertex = Vertex.new(vertex_data)

      new_flow = flow
        |> Flow.add_vertex(vertex, router)

      new_data = Map.put(data, flow_id, new_flow)

      new_router = router
        |> Router.inc_flow_index(flow_id)
        |> Router.add_vertex(vertex.id, flow_id)

      reply = {
        :ok,
        %{
          flow: flow_id,
          vertex: vertex.id,
          vertex_index: Router.get_flow_index(new_router, flow_id)
        }
      }
      {reply, %State{data: new_data, router: new_router}}
    else
      # TODO: return reasonable errors
      _ -> {:error, state}
    end
  end

  def get_vertex(vertex_id, %State{data: data, router: router}) do
    with {:vertex_route, {:ok, {vertex_flow_id, vertex_index}}} <- {:vertex_route, Map.fetch(router, vertex_id)}
    do
      flow_data = Map.get(data, vertex_flow_id)
      vertex = :array.get(vertex_index, flow_data)
      vertex
    else
      # TODO: return reasonable errors
      _ -> :error
    end
  end
end
