defmodule Lifx.Types.GetLocation do
  defstruct [:ignored]
end

defmodule Lifx.Types.StateLocation do
  defstruct location: <<0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0>>,
    label: "", updated_at: 0
end

defimpl Lifx.Decoder, for: [Lifx.Types.GetLocation,
                            Lifx.Types.StateLocation] do

  use Lifx.CodecHelper

  alias Lifx.Types.{GetLocation, StateLocation}

  def decode!(%GetLocation{}, <<>>), do: %GetLocation{}
  def decode!(%StateLocation{}=message, payload) do
    <<location::binary-16,
      label::binary-32,
      updated_at::integer-unsigned-little-size(64)>> = payload
    %{message | location: location, label: unpad(label), updated_at: updated_at}
  end

end

defimpl Lifx.Encoder, for: [Lifx.Types.GetLocation,
                            Lifx.Types.StateLocation] do

  use Lifx.CodecHelper
  alias Lifx.Types.{GetLocation, StateLocation}

  def encode!(%GetLocation{}), do: <<>>
  def encode!(%StateLocation{location: location, label: label, updated_at: updated_at}) do
    label = pad(label, 32)
    <<location::binary-16,
      label::binary-32,
      updated_at::integer-unsigned-little-size(64)>>
  end

end

