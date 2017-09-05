defmodule Lifx.Types.GetGroup do
  defstruct [:ignored]
end

defmodule Lifx.Types.StateGroup do
  defstruct group: <<0,0,0,0,0,0,0,0,0,0,0,0,0,0,0>>,
    label: "", updated_at: 0
end

defimpl Lifx.Decoder, for: [Lifx.Types.GetGroup,
                            Lifx.Types.StateGroup] do

  use Lifx.CodecHelper

  alias Lifx.Types.{GetGroup, StateGroup}

  def decode!(%GetGroup{}, <<>>), do: %GetGroup{}
  def decode!(%StateGroup{}=message, payload) do
    <<group::binary-16,
      label::binary-32,
      updated_at::integer-unsigned-little-size(64)>> = payload
    %{message | group: group, label: unpad(label), updated_at: updated_at}
  end

end

defimpl Lifx.Encoder, for: [Lifx.Types.GetGroup,
                            Lifx.Types.StateGroup] do

  use Lifx.CodecHelper
  alias Lifx.Types.{GetGroup, StateGroup}

  def encode!(%GetGroup{}), do: <<>>
  def encode!(%StateGroup{group: group, label: label, updated_at: updated_at}) do
    label = pad(label, 32)
    <<group::binary-16,
      label::binary-32,
      updated_at::integer-unsigned-little-size(64)>>
  end

end


