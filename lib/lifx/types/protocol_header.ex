defmodule Lifx.Types.ProtocolHeader do
  defstruct type: 0, payload: nil
end

defimpl Lifx.Decoder, for: Lifx.Types.ProtocolHeader do

  alias Lifx.Types.ProtocolHeader

  def decode!(%ProtocolHeader{}=header, payload) when is_binary(payload) do
    <<_reserved::integer-unsigned-little-size(64),
      type::integer-unsigned-little-size(16),
      _reserved1::integer-unsigned-little-size(16)>> = payload
    %{header | type: type}
  end

end

defimpl Lifx.Encoder, for: Lifx.Types.ProtocolHeader do

  alias Lifx.Types.ProtocolHeader

  def encode!(%ProtocolHeader{type: type}) do
    <<0::64, type::integer-unsigned-little-size(16), 0::16>>
  end

end
