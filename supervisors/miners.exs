Code.require_file("workera_miners.exs", __DIR__)
Code.require_file("workerb_miners.exs", __DIR__)

defmodule SupervisorMiners do
  use Supervisor

  def start_link(_) do
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(_) do
    children = [
      WorkerA,
      WorkerB
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def 
end
