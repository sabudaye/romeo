defmodule Romeo.Stanza.Roster.Parser do
  @moduledoc """
  Parses XML records into related structs.
  """
  use Romeo.XML
  import Romeo.XML
  import Romeo.Stanza.AttributeParser

  def parse(xmlel(name: "iq") = stanza) do
    stanza |> Romeo.XML.subelement("query") |> parse
  end
  def parse(xmlel(name: "query") = stanza) do
    stanza |> Romeo.XML.subelements("item") |> Enum.map(&parse/1) |> Enum.reverse
  end
  def parse(xmlel(name: "item", attrs: attrs) = stanza) do
    struct(Item, parse_attrs(attrs))
    |> struct([group: get_group(stanza)])
    |> struct([xml: stanza])
  end
  def parse(nil) do
    []
  end

  defp get_group(stanza), do: subelement(stanza, "group") |> cdata
end
