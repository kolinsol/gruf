defmodule Gruf.State.Storage do
  def add_flow(storage, flow) do
    Map.put(storage, flow.id, flow)
  end

  def put_flow(storage, flow) do
    Map.put(storage, flow.id, flow)
  end

  def get_flow(storage, flow_id) do
    Map.get(storage, flow_id)
  end
end
