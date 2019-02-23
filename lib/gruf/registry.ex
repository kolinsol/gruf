defmodule Gruf.Registry do
  use GenServer

  require Logger

  @name2pid :gruf_name2pid
  @pid2name :gruf_pid2name
  @state_hashes :gruf_state_hashes

  @db_name Application.get_env(:gruf, :dets_db_file_name)
  @table_access_mode Application.get_env(:gruf, :table_access_mode)

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    :ets.new(@name2pid, [:set, @table_access_mode, :named_table])
    :ets.new(@pid2name, [:set, @table_access_mode, :named_table])
    :ets.new(@state_hashes, [:set, @table_access_mode, :named_table])

    {:ok, @db_name} = :dets.open_file(@db_name, [])

    state = init_state()

    {:ok, state}
  end

  def handle_cast({:register, {name, pid}}, state) do
    :ets.insert(@name2pid, {name, pid})
    :ets.insert(@pid2name, {pid, name})

    new_state = add_monitor(state, pid)

    {:noreply, new_state}
  end

  def handle_cast({:unregister, {name, pid}}, state) do
    :ets.delete(@name2pid, name)
    :ets.delete(@pid2name, pid)

    {:noreply, state}
  end

  def handle_cast({:dump_state, name, bin_state}, state) do
    state_hash = :crypto.hash(:sha256, bin_state)
    case :ets.lookup(@state_hashes, name) do
      [{^name, ^state_hash}] ->
        Logger.debug("State hasn't changed")
      [{^name, _state_hash}] ->
        Logger.debug("Updating state dump")
        :ets.insert(@state_hashes, {name, state_hash})
        :dets.insert(@db_name, {name, bin_state})
      [] ->
        Logger.debug("Inserting new state dump")
        :ets.insert(@state_hashes, {name, state_hash})
        :dets.insert(@db_name, {name, bin_state})
    end

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

  def handle_call({:get_state, name}, _from, state) do
    res = case :dets.lookup(@db_name, name) do
      [] -> []
      [{^name, bin_state}] -> bin_state
    end

    {:reply, {:ok, res}, state}
  end

  def handle_info({_msg, monitor_ref, :process, _pid, _reason}, state) do
    new_state = remove_monitor(state, monitor_ref)

    {:noreply, new_state}
  end

  defp init_state() do
    MapSet.new()
  end

  defp add_monitor(monitors, pid) do
    monitor_ref = Process.monitor(pid)

    MapSet.put(monitors, monitor_ref)
  end

  defp remove_monitor(monitors, monitor_ref) do
    true = Process.demonitor(monitor_ref)

    MapSet.delete(monitors, monitor_ref)
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

  def dump_state(pid, bin_state) do
    {:ok, name} = pid2name(pid)

    Logger.info("Dumping state of {#{name}, #{inspect pid}}")

    GenServer.cast(__MODULE__, {:dump_state, name, bin_state})
  end

  def get_state(name) do
    GenServer.call(__MODULE__, {:get_state, name})
  end
end
