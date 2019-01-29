{:ok, _apps} = Application.ensure_all_started(:propcheck)
[{_mod, _bin}] = Code.require_file("util.exs", "./test")
ExUnit.start()
