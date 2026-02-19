defmodule Tasking do
  def asink_task do
    Task.async(fn ->
      :timer.sleep(2000)
      200 + 123 + 1239 + 1 / 20 * 100
    end)
  end

  def await_result(task) do
    result = Task.await(task)
    IO.puts("Hasil perhitungan: #{result}")
  end
end

task = Tasking.asink_task()
IO.puts("Melakukan pekerjaan lain sementara menunggu hasil...")
for i <- 1..200 do
  IO.puts("Bekerja... #{i}")
  :timer.sleep(10)
end
Tasking.await_result(task)
