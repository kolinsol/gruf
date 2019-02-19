defmodule Gruf.DynamicSupervisor do
  use DynamicSupervisor

  alias Gruf.Registry

  def start_link(args) do
    DynamicSupervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def create(name) do
    with true <- Registry.name_available?(name)
    do
      {:ok, bin_state} = Registry.get_state(name)

      child_spec = %{
        id: Gruf.Server,
        start: {Gruf.Server, :start_link, [bin_state]},
        type: :worker
      }

      {:ok, pid} = reply = DynamicSupervisor.start_child(__MODULE__, child_spec)
      Registry.register(name, pid)

      reply
    else
      _ -> {:error, "Name #{name} is already registered"}
    end
  end

  def remove(name) do
    with false <- Registry.name_available?(name)
    do
      {:ok, pid} = Registry.name2pid(name)
      :ok = DynamicSupervisor.terminate_child(__MODULE__, pid)
      Registry.unregister(name, pid)
    else
      _ -> {:error, "Name #{name} is not registered"}
    end
  end
end
