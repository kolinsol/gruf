defmodule Gruf.Util do
  alias Gruf.State
  alias Gruf.State.Router
  alias Gruf.State.Storage

  alias Gruf.Model.Flow
  alias Gruf.Model.Vertex

  def add_flow(vertex_data, %State{storage: storage, router: router}) do
    vertex = Vertex.new(vertex_data)
    flow = Flow.new(vertex)

    new_storage = storage
      |> Storage.add_flow(flow)

    new_router = router
      |> Router.add_route(vertex.id, flow.id, 0)

    reply = {
      :ok, %{
        flow: flow.id,
        vertex: vertex.id,
        vertex_index: 0
      }
    }

    {reply, %State{storage: new_storage, router: new_router}}
  end

  def add_vertex(vertex_data, flow_id, %State{storage: storage, router: router}) do
    flow = Storage.get_flow(storage, flow_id)
    vertex = Vertex.new(vertex_data)
    vertex_index = flow.index

    new_flow = flow
      |> Flow.add_vertex(vertex)

    new_storage = storage
      |> Storage.update_flow(new_flow)

    new_router = router
      |> Router.add_route(vertex.id, flow_id, vertex_index)

    reply = {
      :ok, %{
        flow: flow_id,
        vertex: vertex.id,
        vertex_index: vertex_index
      }
    }

    {reply, %State{storage: new_storage, router: new_router}}
  end

  def get_vertex(vertex_id, %State{storage: storage, router: router}) do
    {flow_id, vertex_index} = Router.get_route(router, vertex_id)

    storage
      |> Storage.get_flow(flow_id)
      |> Flow.get_vertex(vertex_index)
  end
end
