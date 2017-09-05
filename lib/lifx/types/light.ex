defmodule Lifx.Types.HSBK do
  defstruct hue: 65535, saturation: 100, brightness: 32768, kelvin: 5000
end

defmodule Lifx.Types.GetColor do
  defstruct [:ignored]
end

defmodule Lifx.Types.SetColor do
  alias Lifx.Types.HSBK

  defstruct color: %HSBK{}, duration: 1000
end

defmodule Lifx.Types.StateColor do
  alias Lifx.Types.HSBK

  defstruct color: %HSBK{}, power: 0, label: ""
end

defmodule Lifx.Types.GetLightPower do
  defstruct [:ignored]
end

defmodule Lifx.Types.SetLightPower do
  defstruct level: 0, duration: 1000
end

defmodule Lifx.Types.StateLightPower do
  defstruct level: 0
end

defimpl Lifx.Decoder, for: [Lifx.Types.HSBK,
                            Lifx.Types.GetColor,
                            Lifx.Types.SetColor,
                            Lifx.Types.StateColor,
                            Lifx.Types.GetLightPower,
                            Lifx.Types.SetLightPower,
                            Lifx.Types.StateLightPower] do

  use Lifx.CodecHelper
  alias Lifx.Types.{GetColor, SetColor, StateColor,
                    GetLightPower, SetLightPower, StateLightPower, HSBK}

  def decode!(%HSBK{}=hsbk, payload) do
    <<hue::integer-unsigned-little-size(16),
      saturation::integer-unsigned-little-size(16),
      brightness::integer-unsigned-little-size(16),
      kelvin::integer-unsigned-little-size(16)>> = payload
    %{hsbk | hue: hue, saturation: saturation, brightness: brightness, kelvin: kelvin}
  end
  def decode!(%GetColor{}, <<>>), do: %GetColor{}
  def decode!(%GetLightPower{}, <<>>), do: %GetLightPower{}
  def decode!(%SetColor{}=message, payload) do
    <<_reserved::binary-1,
      color::binary-8,
      duration::integer-unsigned-little-size(32)>> = payload
    %{message | duration: duration, color: Lifx.Decoder.decode!(%HSBK{}, color)}
  end
  def decode!(%StateColor{}=message, payload) do
    <<color::binary-8,
      _reserved::binary-2,
      power::integer-unsigned-little-size(16),
      label::binary-32,
      _reserved1::binary-8>> = payload
    %{message | power: power, label: unpad(label), color: Lifx.Decoder.decode!(%HSBK{}, color)}
  end
  def decode!(%SetLightPower{}=message, payload) do
    <<level::integer-unsigned-little-size(16),
      duration::integer-unsigned-little-size(32)>> = payload
    %{message | level: level, duration: duration}
  end
  def decode!(%StateLightPower{}=message, payload) do
    <<level::integer-unsigned-little-size(16)>> = payload
    %{message | level: level}
  end

end

defimpl Lifx.Encoder, for: [Lifx.Types.HSBK,
                            Lifx.Types.GetColor,
                            Lifx.Types.SetColor,
                            Lifx.Types.StateColor,
                            Lifx.Types.GetLightPower,
                            Lifx.Types.SetLightPower,
                            Lifx.Types.StateLightPower] do

  use Lifx.CodecHelper
  alias Lifx.Types.{GetColor, SetColor, StateColor,
                    GetLightPower, SetLightPower, StateLightPower, HSBK}

  def encode!(%HSBK{hue: hue, saturation: saturation, brightness: brightness, kelvin: kelvin}) do
    <<hue::integer-unsigned-little-size(16),
      saturation::integer-unsigned-little-size(16),
      brightness::integer-unsigned-little-size(16),
      kelvin::integer-unsigned-little-size(16)>>
  end
  def encode!(%GetColor{}), do: <<>>
  def encode!(%GetLightPower{}), do: <<>>
  def encode!(%SetColor{color: color, duration: duration}) do
    hsbk = Lifx.Encoder.encode!(color)
    <<0::1, hsbk::binary, duration::integer-unsigned-little-size(32)>>
  end
  def encode!(%StateColor{color: color, power: power, label: label}) do
    hsbk = Lifx.Encoder.encode!(color)
    <<hsbk::binary, 0::2, power::integer-unsigned-little-size(16), (pad(label, 32))::binary-32, 0::1>>
  end
  def encode!(%SetLightPower{level: level, duration: duration}) do
    <<level::integer-unsigned-little-size(16),
      duration::integer-unsigned-little-size(32)>>
  end
  def encode!(%StateLightPower{level: level}) do
    <<level::integer-unsigned-little-size(16)>>
  end

end
