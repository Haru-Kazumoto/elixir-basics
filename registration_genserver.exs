defmodule Registration do
  use GenServer

  # API
  def start_link(_), do: GenServer.start_link(__MODULE__, nil, name: __MODULE__)

  def register(user_id, batch_id) do
    GenServer.call(__MODULE__, {:register, user_id, batch_id})
  end

  @impl true
  def init(_) do
    batches = %{
      1 => %{name: "Kelas Backend", type: :backend, quota: 2, participants: MapSet.new()},
      2 => %{name: "Kelas Frontend", type: :frontend, quota: 2, participants: MapSet.new()},
      3 => %{name: "Kelas DevOps", type: :devops, quota: 2, participants: MapSet.new()}
    }

    state = %{
      batches: batches,
      user_index: %{}
    }

    {:ok, state}
  end

  @impl true
  def handle_call({:register, user_id, batch_id}, _from, state) do
    cond do
      Map.has_key?(state.user_index, user_id) -> {:reply, {:error, :already_registered}, state}
      !Map.has_key?(state.batches, batch_id) -> {:reply, {:error, :batch_not_found}, state}
      true ->
        batch = state.batches[batch_id]

        if MapSet.size(batch.participants) >= batch.quota do
          {:reply, {:error, :full}, state}
        else
          new_batch = %{batch | participants: MapSet.put(batch.participants, user_id)}

          new_state =
            state
            |> put_in([:batches, batch_id], new_batch)
            |> put_in([:user_index, user_id], batch_id)

          {:reply, {:ok, batch.name}, new_state}
        end
    end
  end
end
