defmodule Gruf.Model.Flow do
  alias __MODULE__

  defstruct [:id, :data, :index]

  def new(initial_vertex) do
    %Flow{
      id: gen_id(),
      data: :array.set(0, initial_vertex, :array.new()),
      index: 1
    }
  end

  def add_vertex(flow, vertex) do
    new_data = :array.set(flow.index, vertex, flow.data)
    new_index = flow.index + 1
    %{flow | data: new_data, index: new_index}
  end

  def get_vertex(flow, index) do
    :array.get(index, flow.data)
  end

  def gen_id() do
    ulid = Ulid.generate()
    "flow:#{ulid}"
  end
end
