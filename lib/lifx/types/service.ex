defmodule Lifx.Types.GetService do
  defstruct [:ignored]
end

defmodule Lifx.Types.StateService do
  defstruct service: 1, port: 0
end

defimpl Lifx.Encoder, for: [Lifx.Types.GetService,
                            Lifx.Types.StateService] do

  alias Lifx.Types.{GetService, StateService}

  def encode!(%GetService{}), do: <<>>
  def encode!(%StateService{service: 1, port: port}) do
    <<1::integer-unsigned-little-size(8),
      port::integer-unsigned-little-size(32)>>
  end

end

defimpl Lifx.Decoder, for: [Lifx.Types.GetService,
                            Lifx.Types.StateService] do

  alias Lifx.Types.{GetService, StateService}

  def decode!(%GetService{}=message, <<>>), do: message
  def decode!(%StateService{}=message, payload) do
    <<service::integer-unsigned-little-size(8),
      port::integer-unsigned-little-size(32)>> = payload
    %{message | service: service, port: port}
  end

end
