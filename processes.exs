defmodule ImageProcessor do
  def start_link do
    spawn(fn -> loop() end)
  end

  defp loop do
    receive do
      {:process_image, filename} ->
        IO.puts("Sedang memproses gambar #{filename}...")
        :timer.sleep(3000)
        IO.puts("Gambar #{filename} SELESAI!")
        loop() 
    end
  end
end

worker_pid = ImageProcessor.start_link()

send(worker_pid, {:process_image, "foto_pantai.jpg"})
send(worker_pid, {:process_image, "foto_gunung.jpg"})
send(worker_pid, {:process_image, "selfie.png"})

IO.puts("User bisa lanjut browsing sementara gambar diproses di background!")
