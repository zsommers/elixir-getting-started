defmodule KV do
  @moduledoc """
  Key Value storage.
  """
  use Application

  def start(_type, _args) do
    KV.Supervisor.start_link
  end
end
