defmodule Gruf.Model.Flow do
  alias __MODULE__

  alias Gruf.Model.Vertex

  defstruct [:id, :data, :status]

  def new(initial_vertex) do
    %Flow{
      id: gen_id(),
      data: :array.set(0, initial_vertex, :array.new()),
      status: [vertex_id: initial_vertex.id, index: 0]
    }
  end

  def add_vertex(flow, vertex) do
    new_index = get_next_index(flow)
    new_data = :array.set(new_index, vertex, flow.data)
    new_status = [vertex_id: vertex.id, index: new_index]

    %{flow | data: new_data, status: new_status}
  end

  def link_vertex(flow, new_vertex) do
    last_vertex = get_last_vertex(flow)
    last_index = get_last_index(flow)
    updated_last_vertex =
      Vertex.update_phantom_edge(last_vertex, new_vertex.id)

    insert_vertex(flow, updated_last_vertex, last_index)
  end

  def insert_vertex(flow, vertex, index) do
    new_data = :array.set(index, vertex, flow.data)
    %{flow | data: new_data}
  end

  def get_vertex(flow, index) do
    :array.get(index, flow.data)
  end

  def get_next_index(flow) do
    flow.status[:index] + 1
  end

  def get_last_index(flow) do
    flow.status[:index]
  end

  def get_last_vertex(flow) do
    current_index = get_last_index(flow)
    :array.get(current_index, flow.data)
  end

  def get_last_vertex_id(flow) do
    flow.status[:vertex_id]
  end

  def gen_id() do
    ulid = Ulid.generate()
    "flow:#{ulid}"
  end
end
