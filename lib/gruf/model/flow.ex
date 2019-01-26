defmodule Gruf.Model.Flow do
  alias __MODULE__

  defstruct [:id, :data]

  def new(initial_vertex) do
    %Flow{
      id: gen_id(),
      data: :array.set(0, initial_vertex, :array.new())
    }
  end

  # TODO: remove router
  def add_vertex(flow, vertex, router) do
    index = get_next_index(flow.id, router)
    new_data = :array.set(index, vertex, flow.data)
    %{flow | data: new_data}
  end

  def get_by_id(flow_id, flows) do
    Map.fetch(flows, flow_id)
  end

  def get_next_index(flow_id, router) do
    Map.get(router, flow_id) + 1
  end

  def gen_id() do
    ulid = Ulid.generate()
    "flow:#{ulid}"
  end
end
