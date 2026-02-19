defprotocol RoleUser do
  @fallback_to_any true
  @doc "Returns the role of the user"
  def role(user)
end

defmodule Admin do
  defstruct [:name, :email, :permissions]
end

defmodule User do
  defstruct [:name, :email]
end

defmodule Guest do
  defstruct [:name]
end

defimpl RoleUser, for: Admin do
  def role(user) do
    "Hello #{user.name}, you have admin permissions: #{Enum.join(user.permissions, ", ")}"
  end
end

defimpl RoleUser, for: User do
  def role(user) do
    "Hello #{user.name}, you are a registered user with email: #{user.email}"
  end
end

defimpl RoleUser, for: Guest do
  def role(user) do
    "Hello #{user.name}, you are browsing as a guest."
  end
end

defimpl RoleUser, for: Any do
  def role(_user) do
    "Hello, unknown user type."
  end 
end

defmodule Main do
  def run do
    user = %Admin{name: "Alice", email: "alice@gmail.com", permissions: ["read", "write", "delete"]}
    IO.puts(RoleUser.role(user))
  end
end

Main.run()
