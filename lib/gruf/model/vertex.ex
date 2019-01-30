defmodule Gruf.Model.Vertex do
  alias __MODULE__

  alias Gruf.Model.Edge

  defstruct [:id, :type, :data, :edges]

  def new(type, initial_data) do
    vertex_id = gen_id()
    edge = Edge.new(:phantom, vertex_id)

    %Vertex{
      id: vertex_id,
      type: type,
      data: initial_data,
      edges: %{edge.id => edge}
    }
  end

  # TODO: handle error
  def update_phantom_edge(vertex, to_vertex_id) do
    new_phantom_edge = get_phantom_edge(vertex)
      |> Edge.update_phantom_edge(to_vertex_id)

    update_edge(vertex, new_phantom_edge)
  end

  def get_phantom_edge(vertex) do
    vertex.edges
      |> Map.values()
      |> Enum.find(fn(edge) -> edge.type == :phantom end)
  end

  # TODO: handle error
  def update_edge(vertex, edge) do
    new_edges = Map.put(vertex.edges, edge.id, edge)
    %{vertex | edges: new_edges}
  end

  def gen_id() do
    ulid = Ulid.generate()
    "vertex:#{ulid}"
  end
end
