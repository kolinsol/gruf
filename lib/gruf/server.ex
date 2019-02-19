defmodule Gruf.Server do
  use GenServer

  alias Gruf.Registry
  alias Gruf.State
  alias Gruf.Util

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(args) do
    Process.flag(:trap_exit, true)

    case args do
      [] ->
        {:ok, State.new()}
      bin_state when is_binary(bin_state) ->
        state = :erlang.binary_to_term(bin_state)
        {:ok, state}
    end
  end

  def handle_call({:add_flow, vertex_data}, _from, state) do
    {reply, new_state} = Util.add_flow(vertex_data, state)
    {:reply, reply, new_state}
  end

  def handle_call({:add_vertex, vertex_data, flow_id}, _from, state) do
    {reply, new_state} = Util.add_vertex(vertex_data, flow_id, state)
    {:reply, reply, new_state}
  end

  def handle_call({:get_vertex, vertex_id}, _from, state) do
    reply = Util.get_vertex(vertex_id, state)
    {:reply, reply, state}
  end

  def internal_call(name, msg) do
    with {:ok, pid} <- Registry.name2pid(name)
    do
      GenServer.call(pid, msg)
    else
      _ -> {:error, "Name #{name} is not registered"}
    end
  end

  def terminate(_reason, state) do
    bin_state = :erlang.term_to_binary(state)
    Registry.persist_state(self(), bin_state)
  end
end
