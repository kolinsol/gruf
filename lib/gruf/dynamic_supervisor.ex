defmodule Gruf.DynamicSupervisor do
  use DynamicSupervisor

  def start_link(args) do
    DynamicSupervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def create(_name) do
    child_spec = %{
      id: Gruf.Server,
      start: {Gruf.Server, :start_link, []},
      type: :worker
    }

    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def remove(pid) do
    DynamicSupervisor.terminate_child(__MODULE__, pid)
  end
end
