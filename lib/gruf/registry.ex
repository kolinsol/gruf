defmodule Gruf.Registry do
  use GenServer

  # TODO: add pprocess monitoring
  @name2pid :gruf_name2pid
  @pid2name :gruf_pid2name

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  # TODO: make the tables private
  def init(_args) do
    :ets.new(@name2pid, [:set, :protected, :named_table])
    :ets.new(@pid2name, [:set, :protected, :named_table])

    {:ok, []}
  end

  def handle_cast({:register, {name, pid}}, state) do
    :ets.insert(@name2pid, {name, pid})
    :ets.insert(@pid2name, {pid, name})

    {:noreply, state}
  end

  def handle_cast({:unregister, {name, pid}}, state) do
    :ets.delete(@name2pid, name)
    :ets.delete(@pid2name, pid)

    {:noreply, state}
  end

  def handle_call({:is_name_available, name}, _from, state) do
    reply = case :ets.lookup(@name2pid, name) do
      [_h | _t] -> false
      [] -> true
    end

    {:reply, reply, state}
  end

  def handle_call({:name2pid, name}, _from, state) do
    with [{_name, pid}] <- :ets.lookup(@name2pid, name)
    do
      {:reply, {:ok, pid}, state}
    else
      _ -> {:reply, {:error, "Name #{name} is not registered"}, state}
    end
  end

  def handle_call({:pid2name, pid}, _from, state) do
    with [{_pid, name}] <- :ets.lookup(@pid2name, pid)
    do
      {:reply, {:ok, name}, state}
    else
      _ -> {:reply, {:error, "Can't resolve pid #{pid}"}, state}
    end
  end

  def register(name, pid) do
    GenServer.cast(__MODULE__, {:register, {name, pid}})
  end

  def unregister(name, pid) do
    GenServer.cast(__MODULE__, {:unregister, {name, pid}})
  end

  def name_available?(name) do
    GenServer.call(__MODULE__, {:is_name_available, name})
  end

  def pid2name(pid) do
    GenServer.call(__MODULE__, {:pid2name, pid})
  end

  def name2pid(name) do
    GenServer.call(__MODULE__, {:name2pid, name})
  end
end
