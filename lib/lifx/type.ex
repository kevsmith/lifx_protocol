defmodule Lifx.Type do
  @external_resource Path.join([__DIR__, 'type_ids.txt'])

  for line <- File.stream!(@external_resource, [], :line) do
    [id, module] = line |> String.split(",") |> Enum.map(&String.trim(&1))
    id = String.to_integer(id)
    module = String.to_atom("Elixir.#{module}")

    def id_from_name(unquote(module)), do: unquote(id)
    def create(unquote(id)), do: Kernel.struct(unquote(module))

  end

end
