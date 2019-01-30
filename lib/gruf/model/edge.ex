defmodule Gruf.Model.Edge do
  alias __MODULE__

  defstruct [:id, :type, :from, :to]

  def new(:phantom = type, from) do
    %Edge{
      id: gen_id(),
      type: type,
      from: from
    }
  end

  def new(:solid = type, from, to) do
    %Edge{
      id: gen_id(),
      type: type,
      from: from,
      to: to
    }
  end

  defp gen_id() do
    ulid = Ulid.generate()
    "edge:#{ulid}"
  end
end
