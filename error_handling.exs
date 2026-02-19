defmodule ErrorHandling do
  def read_file(file_path) do
    case File.read(file_path) do
      {:ok, content} -> IO.puts("Isi dari file : #{content}")
      {:error, reason} -> IO.puts("Gagal membaca file: #{reason}")
    end
  end

  def raising() do
    try do
      raise "Terjadi kesalahan!"
    rescue
      e in RuntimeError -> IO.puts("Menangkap kesalahan: #{e.message}")
    end
  end
end

# ErrorHandling.read_file("textd.txt")
ErrorHandling.raising()
