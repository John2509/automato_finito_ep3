defmodule Automato.Pilha do
  @type t :: %Automato.Pilha{
    states: list(String.t()),
    transitions: list(%{
      from_state: String.t(),
      input_symbol: char,
      pop_symbol: char,
      push_symbol: charlist,
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

defimpl Automato.Run, for: Automato.Pilha do
  @spec run(Automato.Pilha.t, TapeWithStack.t, String.t, list(String.t)) :: boolean()
  def run(automato, tape = %TapeWithStack{}, from_state, hasBeenWhileEmpty) do
    if (from_state in hasBeenWhileEmpty) do
      false
    else
      read = TapeWithStack.read(tape);

      transitions_empty = Enum.filter(automato.transitions, fn transition ->
        transition.from_state == from_state
        and transition.input_symbol == ?\0
        and transition.pop_symbol == ?\0
      end)
      transitions_empty_input = Enum.filter(automato.transitions, fn transition ->
        transition.from_state == from_state
        and transition.input_symbol == ?\0
        and transition.pop_symbol == read.stack_elem
      end)

      if read.tape_elem == ?\s do
        Enum.member?(automato.accepting_states, from_state)
        or
        Enum.any?(transitions_empty, fn transition ->
          run(automato, TapeWithStack.reconfig(tape, false, transition.push_symbol), transition.to_state, [from_state | hasBeenWhileEmpty])
        end)
        or
        Enum.any?(transitions_empty_input, fn transition ->
          run(automato, TapeWithStack.reconfig(read.tape_with_stack, false, transition.push_symbol), transition.to_state, [])
        end)
      else

        transitions_empty_pop = Enum.filter(automato.transitions, fn transition ->
          transition.from_state == from_state
          and transition.input_symbol == read.tape_elem
          and transition.pop_symbol == ?\0
        end)
        transitions = Enum.filter(automato.transitions, fn transition ->
          transition.from_state == from_state
          and transition.input_symbol == read.tape_elem
          and transition.pop_symbol == read.stack_elem
        end)

        Enum.any?(transitions_empty, fn transition ->
          run(automato, TapeWithStack.reconfig(tape, false, transition.push_symbol), transition.to_state, [from_state | hasBeenWhileEmpty])
        end)
        or
        Enum.any?(transitions_empty_input, fn transition ->
          run(automato, TapeWithStack.reconfig(read.tape_with_stack, false, transition.push_symbol), transition.to_state, [])
        end)
        or
        Enum.any?(transitions_empty_pop, fn transition ->
          run(automato, TapeWithStack.reconfig(tape, true, transition.push_symbol), transition.to_state, [])
        end)
        or
        Enum.any?(transitions, fn transition ->
          run(automato, TapeWithStack.reconfig(read.tape_with_stack, true, transition.push_symbol), transition.to_state, [])
        end)
      end
    end
  end
end
