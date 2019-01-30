defmodule Gruf.Model.Vertex do
  alias __MODULE__

  defstruct [:id, :type, :data, :edges]

  def new(type, initial_data) do
    %Vertex{
      id: gen_id(),
      type: type,
      data: initial_data,
      edges: []
    }
  end

  def gen_id() do
    ulid = Ulid.generate()
    "vertex:#{ulid}"
  end
end
