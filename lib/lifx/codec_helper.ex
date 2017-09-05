defmodule Lifx.CodecHelper do

  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__), only: [pad: 2, unpad: 1]
    end
  end

  @doc "Right pads data with NULs to desired length"
  def pad(data, desired) do
    remaining = desired - :erlang.size(data)
    if remaining < 1 do
      data
    else
      pad1(data, remaining)
    end
  end

  @doc "Removes right padded NULs"
  def unpad(data), do: unpad(data, <<>>)

  defp pad1(data, 0), do: data
  defp pad1(data, remaining) do
    pad1(<<data::binary, 0>>, remaining - 1)
  end

  defp unpad(<<h::binary-1, data::binary>>, accum) do
    case h do
      <<0>> ->
        accum
      _ ->
        unpad(data, <<accum::binary, h::binary>>)
    end
  end

end
