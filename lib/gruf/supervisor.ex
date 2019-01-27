defmodule Gruf.Supervisor do
  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    children = [
      %{
        id: Gruf.DynamicSupervisor,
        start: {Gruf.DynamicSupervisor, :start_link, [:ok]},
        type: :supervisor
      },
      %{
        id: Gruf.Registry,
        start: {Gruf.Registry, :start_link, [:ok]},
        type: :worker
      }
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
