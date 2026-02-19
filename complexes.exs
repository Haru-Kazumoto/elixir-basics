defmodule ComplexApp.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: ComplexApp.Registry},
      {DynamicSupervisor, strategy: :one_for_one, name: ComplexApp.WorkerSupervisor},
      ComplexApp.JobManager
    ]

    opts = [strategy: :one_for_one, name: ComplexApp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

defmodule ComplexApp.JobManager do
  use GenServer

  @check_interval 5_000

  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    schedule_check()
    {:ok, Map.put(state, :jobs_processed, 0)}
  end

  def submit_job(data) do
    GenServer.cast(__MODULE__, {:submit_job, data})
  end

  def get_stats do
    GenServer.call(__MODULE__, :stats)
  end

  def handle_cast({:submit_job, data}, state) do
    {:ok, pid} =
      DynamicSupervisor.start_child(
        ComplexApp.WorkerSupervisor,
        {ComplexApp.Worker, data}
      )

    Process.monitor(pid)
    {:noreply, state}
  end

  def handle_call(:stats, _from, state) do
    {:reply, state, state}
  end

  def handle_info(:check_load, state) do
    IO.puts("System running. Jobs processed: #{state.jobs_processed}")
    schedule_check()
    {:noreply, state}
  end

  def handle_info({:DOWN, _ref, :process, _pid, _reason}, state) do
    new_state = Map.update!(state, :jobs_processed, &(&1 + 1))
    {:noreply, new_state}
  end

  defp schedule_check do
    Process.send_after(self(), :check_load, @check_interval)
  end
end

defmodule ComplexApp.Worker do
  use GenServer

  def start_link(data) do
    GenServer.start_link(__MODULE__, data)
  end

  def init(data) do
    send(self(), {:process, data})
    {:ok, %{data: data, started_at: DateTime.utc_now()}}
  end

  def handle_info({:process, data}, state) do
    result = heavy_computation(data)
    IO.puts("Processed job: #{inspect(result)}")
    {:stop, :normal, state}
  end

  defp heavy_computation(data) do
    Task.async(fn ->
      :timer.sleep(Enum.random(1000..3000))
      Enum.reduce(1..10000, 0, fn x, acc ->
        acc + :math.sqrt(x)
      end)
      %{original: data, status: :done}
    end)
    |> Task.await(5000)
  end
end
