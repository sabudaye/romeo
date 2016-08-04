defmodule Romeo.AttributeParser do

  use Romeo.XML
  import Romeo.XML

  def parse_attrs([]), do: []
  def parse_attrs(attrs) do
    parse_attrs(attrs, [])
  end
  def parse_attrs([{k,v}|rest], acc) do
    parse_attrs(rest, [parse_attr({k,v})|acc])
  end
  def parse_attrs([], acc), do: acc

  def parse_attr({key, value}) when key in ["to", "from", "jid"] do
    {String.to_atom(key), Romeo.JID.parse(value)}
  end
  def parse_attr({key, value}) do
    {String.to_atom(key), value}
  end
end
