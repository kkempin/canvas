defmodule Canvas.DrawingWorker do
  use GenServer

  @interval 5_000

  def start_link(_state) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    Process.send_after(self(), :work, @interval)
    {:ok, %{last_run_at: nil}}
  end

  def handle_info(:work, _state) do
    Canvas.DrawingService.process_drawing_operations()
    Process.send_after(self(), :work, @interval)

    {:noreply, %{last_run_at: :calendar.local_time()}}
  end
end
