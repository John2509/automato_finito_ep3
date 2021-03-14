defmodule AutomatoDeterministico do
  @spec start(ReadOnlyTape.t | TapeWithStack.t, Automato.Finito.t | Automato.Pilha.t) :: boolean()
  def start(tape, automato) do
    final_state = _next_state(automato.initial_state, tape, automato)
    Enum.member?(automato.accepting_states, final_state)
  end

  @spec _next_state(String.t, ReadOnlyTape.t, Automato.Finito.t) :: String.t
  def _next_state(from_state, tape = %ReadOnlyTape{}, automato = %Automato.Finito{}) do
    read = ReadOnlyTape.read(tape);
    if read == ?\s do
      from_state
    else
      transition = Enum.find(automato.transitions, fn transition ->
        transition.from_state == from_state and transition.symbol == read
      end)

      _next_state(transition.to_state, ReadOnlyTape.reconfig(tape), automato)
    end
  end

  @spec _next_state(String.t, TapeWithStack.t, Automato.Pilha.t) :: String.t
  def _next_state(from_state, tape = %TapeWithStack{}, automato = %Automato.Pilha{}) do
    read = TapeWithStack.read(tape);
    if read.tape_elem == ?\s do
      from_state
    else
      transition = Enum.find(automato.transitions, fn transition ->
        transition.from_state == from_state
        and transition.input_symbol == read.tape_elem
        and transition.pop_symbol == read.stack_elem
      end)

      _next_state(transition.to_state, TapeWithStack.reconfig(read.tape_with_stack, true, transition.push_symbol), automato)
    end
  end

end
