defmodule Automato do
  @spec start(any, any) :: boolean()
  def start(tape, automato) do
    Automato.Run.run(automato, tape, automato.initial_state, [])
  end

  defprotocol Run do
    @spec run(any, any, String.t, list(String.t)) :: boolean()
    def run(automato, tape, from_state, hasBeenWhileEmpty)
  end
end
