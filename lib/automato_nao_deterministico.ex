defmodule AutomatoNaoDeterministico do
  @spec start(ReadOnlyTape.t | TapeWithStack.t, Automato.Finito.t | Automato.Pilha.t) :: boolean()
  def start(tape, automato) do
    _run(automato.initial_state, tape, automato, [])
  end

  @spec _run(String.t, ReadOnlyTape.t, Automato.Finito.t, list(String.t)) :: boolean()
  def _run(from_state, tape = %ReadOnlyTape{}, automato = %Automato.Finito{}, hasBeenWhileEmpty) do
    if (from_state in hasBeenWhileEmpty) do
      false
    else
      read = ReadOnlyTape.read(tape);

      transitions_empty = Enum.filter(automato.transitions, fn transition ->
        transition.from_state == from_state and transition.symbol == ?\0
      end)

      if (read == ?\s) do
        Enum.member?(automato.accepting_states, from_state)
        or
        Enum.any?(transitions_empty, fn transition ->
          _run(transition.to_state, tape, automato, [from_state | hasBeenWhileEmpty])
        end)
      else

        transitions = Enum.filter(automato.transitions, fn transition ->
          transition.from_state == from_state and transition.symbol == read
        end)

        Enum.any?(transitions_empty, fn transition ->
          _run(transition.to_state, tape, automato, [from_state | hasBeenWhileEmpty])
        end)
        or
        Enum.any?(transitions, fn transition ->
          _run(transition.to_state, ReadOnlyTape.reconfig(tape), automato, [])
        end)
      end
    end
  end

  @spec _run(String.t, TapeWithStack.t, Automato.Pilha.t, list(String.t)) :: boolean()
  def _run(from_state, tape = %TapeWithStack{}, automato = %Automato.Pilha{}, hasBeenWhileEmpty) do
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
          _run(transition.to_state, TapeWithStack.reconfig(tape, false, transition.push_symbol), automato, [from_state | hasBeenWhileEmpty])
        end)
        or
        Enum.any?(transitions_empty_input, fn transition ->
          _run(transition.to_state, TapeWithStack.reconfig(read.tape_with_stack, false, transition.push_symbol), automato, [])
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
          _run(transition.to_state, TapeWithStack.reconfig(tape, false, transition.push_symbol), automato, [from_state | hasBeenWhileEmpty])
        end)
        or
        Enum.any?(transitions_empty_input, fn transition ->
          _run(transition.to_state, TapeWithStack.reconfig(read.tape_with_stack, false, transition.push_symbol), automato, [])
        end)
        or
        Enum.any?(transitions_empty_pop, fn transition ->
          _run(transition.to_state, TapeWithStack.reconfig(tape, true, transition.push_symbol), automato, [])
        end)
        or
        Enum.any?(transitions, fn transition ->
          _run(transition.to_state, TapeWithStack.reconfig(read.tape_with_stack, true, transition.push_symbol), automato, [])
        end)
      end
    end
  end

end
