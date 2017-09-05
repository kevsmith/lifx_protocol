defmodule Lifx.Types.GetWifiInfo do
  defstruct [:ignored]
end

defmodule Lifx.Types.StateWifiInfo do
  defstruct signal: 0.0, tx: 0, rx: 0
end

defmodule Lifx.Types.GetWifiFirmware do
  defstruct [:ignored]
end

defmodule Lifx.Types.StateWifiFirmware do
  defstruct build: 0, version: 0
end

defimpl Lifx.Decoder, for: [Lifx.Types.GetWifiInfo,
                            Lifx.Types.StateWifiInfo,
                            Lifx.Types.GetWifiFirmware,
                            Lifx.Types.StateWifiFirmware] do

  alias Lifx.Types.{GetWifiInfo, StateWifiInfo, GetWifiFirmware, StateWifiFirmware}

  def decode!(%GetWifiInfo{}, <<>>), do: %GetWifiInfo{}
  def decode!(%GetWifiFirmware{}, <<>>), do: %GetWifiFirmware{}
  def decode!(%StateWifiInfo{}=message, payload) do
    <<signal::float-size(32),
      tx::integer-unsigned-little-size(32),
      rx::integer-unsigned-little-size(32),
      0::16>> = payload
    %{message | signal: signal, tx: tx, rx: rx}
  end
  def decode!(%StateWifiFirmware{}=message, payload) do
    <<build::integer-unsigned-little-size(64),
      _reserved::integer-unsigned-little-size(64),
      version::integer-unsigned-little-size(32)>> = payload
    %{message | build: build, version: version}
  end

end

defimpl Lifx.Encoder, for: [Lifx.Types.GetWifiInfo,
                            Lifx.Types.StateWifiInfo,
                            Lifx.Types.GetWifiFirmware,
                            Lifx.Types.StateWifiFirmware] do

  alias Lifx.Types.{GetWifiInfo, StateWifiInfo, GetWifiFirmware, StateWifiFirmware}

  def encode!(%GetWifiInfo{}), do: <<>>
  def encode!(%GetWifiFirmware{}), do: <<>>
  def encode!(%StateWifiInfo{signal: signal, tx: tx, rx: rx}) do
    <<signal::float-size(32),
      tx::integer-unsigned-little-size(32),
      rx::integer-unsigned-little-size(32),
      0::16>>
  end
  def encode!(%StateWifiFirmware{build: build, version: version}) do
    <<build::integer-unsigned-little-size(64),
      0::64,
      version::integer-unsigned-little-size(32)>>
  end

end
