defmodule Gruf.State do
  alias __MODULE__

  defstruct [:storage, :router]

  def new() do
    %State{storage: %{}, router: %{}}
  end
end
