defmodule Gruf.Util do
  alias Gruf.State
  alias Gruf.State.Router
  alias Gruf.State.Storage

  alias Gruf.Model.Flow
  alias Gruf.Model.Vertex

  def add_flow(vertex_data, %State{storage: storage, router: router}) do
    vertex = Vertex.new(vertex_data)
    flow = Flow.new(vertex)

    new_storage = Storage.add_flow(storage, flow)

    new_router = router
      |> Router.init_flow_index(flow.id)
      |> Router.add_vertex(vertex.id, flow.id)

    reply = {
      :ok, %{
        flow: flow.id,
        vertex: vertex.id,
        vertex_index: 0
      }
    }

    {reply, %State{storage: new_storage, router: new_router}}
  end

  def add_vertex(vertex_data, flow_id, %State{storage: storage, router: router} = state) do
    with {:flow, {:ok, flow}} <- {:flow, Flow.get_by_id(flow_id, storage)}
    do
      vertex = Vertex.new(vertex_data)

      new_flow = flow
        |> Flow.add_vertex(vertex, router)

      new_storage = Storage.put_flow(storage, new_flow)

      new_router = router
        |> Router.inc_flow_index(flow_id)
        |> Router.add_vertex(vertex.id, flow_id)

      reply = {
        :ok, %{
          flow: flow_id,
          vertex: vertex.id,
          vertex_index: Router.get_flow_index(new_router, flow_id)
        }
      }

      {reply, %State{storage: new_storage, router: new_router}}
    else
      # TODO: return reasonable errors
      _ -> {:error, state}
    end
  end

  def get_vertex(vertex_id, %State{storage: storage, router: router}) do
    with {:vertex_route, {:ok, {flow_id, vertex_index}}} <- {:vertex_route, Map.fetch(router, vertex_id)}
    do
      storage
        |> Storage.get_flow(flow_id)
        |> Flow.get_vertex(vertex_index)
    else
      # TODO: return reasonable errors
      _ -> :error
    end
  end
end
