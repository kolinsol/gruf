defmodule Gruf.Model.Edge do
  defstruct [:id, :type, :from_vertex, :to_vertex]

  defp gen_id() do
    ulid = Ulid.generate()
    "edge:#{ulid}"
  end
end
