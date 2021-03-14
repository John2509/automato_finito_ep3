defmodule Automato.Finito do
  @type t :: %Automato.Finito{
    states: list(String.t()),
    transitions: list(%{
      from_state: String.t(),
      input_symbol: char,
      to_state: String.t()
    }),
    initial_state: String.t(),
    accepting_states: list(String.t())
  }
	defstruct [
    states: ["q0"],
    transitions: [],
    initial_state: "q0",
    accepting_states: ["q0"]
  ]
end

defimpl Automato.Run, for: Automato.Finito do
  @spec run(Automato.Finito.t, ReadOnlyTape.t, String.t, list(String.t)) :: boolean()
  def run(automato, tape = %ReadOnlyTape{}, from_state, hasBeenWhileEmpty) do
    if (from_state in hasBeenWhileEmpty) do
      false
    else
      read = ReadOnlyTape.read(tape);

      transitions_empty = Enum.filter(automato.transitions, fn transition ->
        transition.from_state == from_state and transition.input_symbol == ?\0
      end)

      if (read == ?\s) do
        Enum.member?(automato.accepting_states, from_state)
        or
        Enum.any?(transitions_empty, fn transition ->
          run(automato, tape, transition.to_state, [from_state | hasBeenWhileEmpty])
        end)
      else

        transitions = Enum.filter(automato.transitions, fn transition ->
          transition.from_state == from_state and transition.input_symbol == read
        end)

        Enum.any?(transitions_empty, fn transition ->
          run(automato, tape, transition.to_state, [from_state | hasBeenWhileEmpty])
        end)
        or
        Enum.any?(transitions, fn transition ->
          run(automato, ReadOnlyTape.reconfig(tape), transition.to_state, [])
        end)
      end
    end
  end
end
