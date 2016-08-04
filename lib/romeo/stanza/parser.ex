defmodule Romeo.Stanza.Parser do
  @moduledoc """
  Parses XML records into related structs.
  """
  use Romeo.XML
  import Romeo.XML
  import Romeo.Stanza.AttributeParser

  def parse(xmlel(name: "message", attrs: attrs) = stanza) do
    struct(Message, parse_attrs(attrs))
    |> struct([body: get_body(stanza)])
    |> struct([html: get_html(stanza)])
    |> struct([xml: stanza])
    |> struct([delayed?: delayed?(stanza)])
  end

  def parse(xmlel(name: "presence", attrs: attrs) = stanza) do
    struct(Presence, parse_attrs(attrs))
    |> struct([show: get_show(stanza)])
    |> struct([status: get_status(stanza)])
    |> struct([xml: stanza])
  end

  def parse(xmlel(name: "iq", attrs: attrs) = stanza) do
    struct(IQ, parse_attrs(attrs))
    |> struct([xml: stanza])
  end

  def parse(xmlel(name: name, attrs: attrs) = stanza) do
    [name: name]
    |> Dict.merge(parse_attrs(attrs))
    |> Dict.merge([xml: stanza])
    |> Enum.into(%{})
  end

  def parse(xmlcdata(content: content)), do: content

  def parse(stanza), do: stanza

  defp get_body(stanza), do: subelement(stanza, "body") |> cdata
  defp get_html(stanza), do: subelement(stanza, "html")

  defp get_show(stanza), do: subelement(stanza, "show") |> cdata
  defp get_status(stanza), do: subelement(stanza, "status") |> cdata

  defp delayed?(xmlel(children: children)) do
    Enum.any? children, fn child ->
      elem(child, 1) == "delay" || elem(child, 1) == "x" &&
        attr(child, "xmlns") == "jabber:x:delay"
    end
  end
end
