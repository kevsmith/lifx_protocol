defmodule Lifx.Types.GetHostInfo do
  defstruct [:ignored]
end

defmodule Lifx.Types.StateHostInfo do
  defstruct signal: 0.0, tx: 0, rx: 0
end

defmodule Lifx.Types.GetHostFirmware do
  defstruct [:ignored]
end

defmodule Lifx.Types.StateHostFirmware do
  defstruct build: 0, version: 0
end

defimpl Lifx.Decoder, for: [Lifx.Types.GetHostInfo,
                            Lifx.Types.StateHostInfo,
                            Lifx.Types.GetHostFirmware,
                            Lifx.Types.StateHostFirmware] do

  alias Lifx.Types.{GetHostInfo, StateHostInfo, GetHostFirmware, StateHostFirmware}

  def decode!(%GetHostInfo{}, <<>>), do: %GetHostInfo{}
  def decode!(%GetHostFirmware{}, <<>>), do: %GetHostFirmware{}
  def decode!(%StateHostInfo{}=message, payload) do
    IO.inspect payload
    <<signal::float-little-size(32),
      tx::integer-unsigned-little-size(32),
      rx::integer-unsigned-little-size(32),
      _reserved::integer-unsigned-little-size(16)>> = payload
    %{message | signal: signal, tx: tx, rx: rx}
  end
  def decode!(%StateHostFirmware{}=message, payload) do
    <<build::integer-unsigned-little-size(64),
      _reserved::integer-unsigned-little-size(64),
      version::integer-unsigned-little-size(32)>> = payload
    %{message | build: build, version: version}
  end

end

defimpl Lifx.Encoder, for: [Lifx.Types.GetHostInfo,
                            Lifx.Types.StateHostInfo,
                            Lifx.Types.GetHostFirmware,
                            Lifx.Types.StateHostFirmware] do

  alias Lifx.Types.{GetHostInfo, StateHostInfo, GetHostFirmware, StateHostFirmware}

  def encode!(%GetHostInfo{}), do: <<>>
  def encode!(%GetHostFirmware{}), do: <<>>
  def encode!(%StateHostInfo{signal: signal, tx: tx, rx: rx}) do
    <<signal::float-size(32),
      tx::integer-unsigned-little-size(32),
      rx::integer-unsigned-little-size(32),
      0::16>>
  end
  def encode!(%StateHostFirmware{build: build, version: version}) do
    <<build::integer-unsigned-little-size(64),
      0::64,
      version::integer-unsigned-little-size(32)>>
  end

end
