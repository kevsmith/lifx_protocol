defmodule Lifx.Frame do

  use Bitwise, only_operators: true
  alias Lifx.Encoder

  @doc "Creates a properly formated Lifx frame"
  @spec create(message::Map.t(), opts::Keyword.t()) :: {:ok, pos_integer(), binary()}
  def create(message, opts \\ []) do
    target = Keyword.get(opts, :target, 0)
    tagged = convert_bool(Keyword.get(opts, :tagged, false))
    ack = convert_bool(Keyword.get(opts, :req_ack, false))
    res = convert_bool(Keyword.get(opts, :req_res, false))
    source = case Keyword.get(opts, :source, nil) do
               nil ->
                 range = 65534 <<< 1
                 ((:rand.uniform(range) - 1) >>> 1) + 1
               s ->
                 s
             end
    payload = Encoder.encode!(message)
    frame_header = build_frame_header(tagged, source)
    frame_address = <<target::integer-unsigned-little-size(64),
                      0::48,
                      0::6,
                      ack::1,
                      res::1,
                      1::8>>
    message_type = Lifx.Type.id_from_name(message.__struct__)
    protocol_header = <<0::64, message_type::integer-unsigned-little-size(16), 0::16>>
    body = frame_header <> frame_address <> protocol_header <> payload
    packet = <<byte_size(body)+2::little-unsigned-size(16)>> <> body
    {:ok, source, packet}
  end

  @doc "Parses a raw Lifx frame"
  @spec parse(data::binary()) :: term()
  def parse(data) when is_binary(data) do
    <<size::integer-unsigned-little-size(16), otap::bits-16,
      source::integer-unsigned-little-size(32), payload::binary>> = data
    otap = reverse_bits(otap)
    <<_origin::2, tagged::1, addressable::1, protocol::12>> = otap
    cond do
      size != :erlang.size(data) ->
        IO.puts("#{size}\n#{:erlang.size(data)}")
        {:error, :bad_frame_size}
      addressable != 1 ->
        {:error, :bad_frame_addressable}
      protocol != 1024 ->
        {:error, :bad_frame_protocol}
      true ->
        case parse_payload(payload) do
          {:ok, _target, parsed} ->
            {:ok, tagged, source, parsed}
          error ->
            error
        end
    end
  end

  defp build_frame_header(tagged, source) do
    reverse_bits(<<0::2, tagged::1, 1::1, 1024::12>>) <> <<source::integer-unsigned-little-size(32)>>
  end

  defp parse_payload(payload) do
    <<target::integer-unsigned-little-size(64),
      _::64, pheader::binary>> = payload
    <<_::64, type::integer-unsigned-little-size(16), _::16, message::binary>> = pheader
    parsed = Lifx.Decoder.decode!(Lifx.Type.create(type), message)
    {:ok, target, parsed}
  end

  defp convert_bool(true), do: 1
  defp convert_bool(_), do: 0


  def reverse_bits(<<a, b>>), do: <<b, a>>

end
