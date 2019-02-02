defmodule Gruf.Model.Vertex do
  alias __MODULE__

  alias Gruf.Model.Edge

  @type type() :: :initial
                | :regular

  @type t() :: %Gruf.Model.Vertex{
    id: String.t(),
    type: Vertex.type(),
    data: map(),
    edges: map()
  }

  defstruct [:id, :type, :data, :edges]

  @spec new(Vertex.type(), map()) :: Vertex.t()
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
  @spec update_phantom_edge(Vertex.t(), String.t()) :: Vertex.t()
  def update_phantom_edge(vertex, to_vertex_id) do
    new_phantom_edge = get_phantom_edge(vertex)
      |> Edge.update_phantom_edge(to_vertex_id)

    update_edge(vertex, new_phantom_edge)
  end

  @spec get_phantom_edge(Vertex.t()) :: Edge.t()
  def get_phantom_edge(vertex) do
    vertex.edges
      |> Map.values()
      |> Enum.find(fn(edge) -> edge.type == :phantom end)
  end

  # TODO: handle error
  @spec update_edge(Vertex.t(), Edge.t()) :: Vertex.t()
  def update_edge(vertex, edge) do
    new_edges = Map.put(vertex.edges, edge.id, edge)
    %{vertex | edges: new_edges}
  end

  @spec gen_id() :: String.t()
  def gen_id() do
    ulid = Ulid.generate()
    "vertex:#{ulid}"
  end
end
