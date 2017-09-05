defmodule Lifx.Types.GetPower do
  defstruct [:ignored]
end

defmodule Lifx.Types.SetPower do
  defstruct level: 0
end

defmodule Lifx.Types.StatePower do
  defstruct level: 0
end

defimpl Lifx.Decoder, for: [Lifx.Types.GetPower,
                            Lifx.Types.SetPower,
                            Lifx.Types.StatePower] do

  alias Lifx.Types.{GetPower, SetPower, StatePower}

  def decode!(%GetPower{}=message, <<>>), do: message
  def decode!(%SetPower{}=message, payload) do
    <<level::integer-unsigned-little-size(16)>> = payload
    %{message | level: level}
  end
  def decode!(%StatePower{}=message, payload) do
    <<level::integer-unsigned-little-size(16)>> = payload
    %{message | level: level}
  end

end

defimpl Lifx.Encoder, for: [Lifx.Types.GetPower,
                            Lifx.Types.SetPower,
                            Lifx.StatePower] do

  alias Lifx.Types.{GetPower, SetPower, StatePower}

  def encode!(%GetPower{}), do: <<>>
  def encode!(%SetPower{level: level}) when level == 0 or level == 65535 do
    <<level::integer-unsigned-little-size(16)>>
  end
  def encode!(%StatePower{level: level}) when level == 0 or level == 65535 do
    <<level::integer-unsigned-little-size(16)>>
  end

end
