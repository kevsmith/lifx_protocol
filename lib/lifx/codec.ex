defprotocol Lifx.Encoder do

  @doc "Encodes a Lifx protocol type into binary format"
  @spec encode!(type :: term()) :: binary() | no_return()
  def encode!(type)

end

defprotocol Lifx.Decoder do

  @doc "Decodes binary data into Lifx protocol type(s)"
  @spec decode!(type :: term(), data :: binary()) :: term() | no_return()
  def decode!(type, data)

end
