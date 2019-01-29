defmodule Gruf.Test.Vertex do
  use ExUnit.Case
  use PropCheck

  import Gruf.Test.Util

  alias Gruf.Model.Vertex

  property "should generate correct vertex id" do
    forall ulid <- ulid() do
      id_regex = ~r/^vertex:[0-9A-HJKMNP-TV-Z]{26}$/
      true = Regex.match?(id_regex, "vertex:#{ulid}")
      true = Regex.match?(id_regex, Vertex.gen_id())
    end
  end
end
