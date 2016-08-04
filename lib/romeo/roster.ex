defmodule Romeo.Roster do
  @moduledoc """
  Helper for work with roster
  """
  @timeout 5_000

  use Romeo.XML
  alias Romeo.Connection, as: Conn
  alias Romeo.Stanza
  require Logger

  @doc """
  Returns roster items
  """
  def items(pid) do
    Logger.info fn -> "Getting roster items" end
    stanza = Stanza.get_roster
    :ok = Conn.send(pid, stanza)
    receive do
      {:stanza, %IQ{type: "result"} = result} ->
        items = result.xml |> Romeo.Roster.Parser.parse
    after @timeout ->
      {:error, :timeout}
    end
  end

  @doc """
  Adds jid to roster
  """
  def add(pid, jid) do
    Logger.info fn -> "Adding #{jid} to roster items" end
    stanza = Stanza.set_to_roster(jid)
    :ok = Conn.send(pid, stanza)
    receive do
      {:stanza, %IQ{type: "result"}} -> :ok
      {:stanza, %IQ{type: "error"}} -> :error
    after @timeout ->
      {:error, :timeout}
    end
  end

  @doc """
  Removes jid to roster
  """
  def remove(pid, jid) do
    Logger.info fn -> "Removing #{jid} from roster items" end
    stanza = Stanza.set_to_roster(jid, "remove")
    :ok = Conn.send(pid, stanza)
    receive do
      {:stanza, %IQ{type: "result"}} -> :ok
      {:stanza, %IQ{type: "error"}} -> :error
    after @timeout ->
      {:error, :timeout}
    end
  end
end
