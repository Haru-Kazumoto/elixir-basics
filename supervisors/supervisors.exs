defmodule SomeServers do
  use GenServer

  def start_link(_) do
    IO.puts("Some Server is ready")
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def child_spec(_arg) do
    %{
      id: :some_server,
      start: {__MODULE__, :start_link, [[]]},
      restart: :transient,
      #:transient -> stop selain :normal,
      #:permanen -> akan terus jalan no matter what,
      #:temporary -> sekali mati supervisor ga peduli njir
      shutdown: 10_000,
      type: :worker
    }
  end

  @impl true
  def init(_) do
    {:ok, "Server is up"}
  end
end

defmodule SomeSupervisors do
  use Supervisor

  def start_link do
    IO.puts("Some Supervisor is starting")
    Supervisor.start_link(__MODULE__, :ok, name: :some_supervisor)
  end

  def init(_arg) do
    children = [
      SomeServers
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
