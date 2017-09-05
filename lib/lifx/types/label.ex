defmodule Lifx.Types.GetLabel do
  defstruct [:ignored]
end

defmodule Lifx.Types.SetLabel do
  defstruct label: ""
end

defmodule Lifx.Types.StateLabel do
  defstruct label: ""
end

defimpl Lifx.Decoder, for: [Lifx.Types.GetLabel,
                            Lifx.Types.SetLabel,
                            Lifx.Types.StateLabel] do

  alias Lifx.Types.{GetLabel, SetLabel, StateLabel}

  def decode!(%GetLabel{}, <<>>), do: %GetLabel{}
  def decode!(%SetLabel{}=message, payload) when :erlang.size(payload) < 33 do
    %{message | label: payload}
  end
  def decode!(%StateLabel{}=message, payload) when :erlang.size(payload) < 33 do
    %{message | label: payload}
  end

end

defimpl Lifx.Encoder, for: [Lifx.Types.GetLabel,
                            Lifx.Types.SetLabel,
                            Lifx.Types.StateLabel] do

  alias Lifx.Types.{GetLabel, SetLabel, StateLabel}

  def encode!(%GetLabel{}), do: <<>>
  def encode!(%SetLabel{label: label}) when :erlang.size(label) < 33 do
    <<label::binary>>
  end
  def encode!(%StateLabel{label: label}) when :erlang.size(label) < 33 do
    <<label::binary>>
  end

end
