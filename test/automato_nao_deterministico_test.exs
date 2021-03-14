defmodule AutomatoNaoDeterministicoTest do
  use ExUnit.Case
  doctest AutomatoNaoDeterministico

  describe "AutomatoFinito" do
    test "simple" do
      transitions = [
        %{
          from_state: "q0",
          symbol: ?a,
          to_state: "q1"
        },
        %{
          from_state: "q0",
          symbol: ?a,
          to_state: "q3"
        },
        %{
          from_state: "q1",
          symbol: ?a,
          to_state: "q2"
        }
      ]
      automato = %Automato.Finito{
        states: ["q0", "q1", "q2", "q3"],
        transitions: transitions,
        initial_state: "q0",
        accepting_states: ["q2"]
      }
      tape0 = ReadOnlyTape.init([])
      tape1 = ReadOnlyTape.init([?a])
      tape2 = ReadOnlyTape.init([?a, ?a])
      tape3 = ReadOnlyTape.init([?a, ?a, ?a])
      tape4 = ReadOnlyTape.init([?a, ?a, ?a, ?a])
      test0 = AutomatoNaoDeterministico.start(tape0, automato)
      test1 = AutomatoNaoDeterministico.start(tape1, automato)
      test2 = AutomatoNaoDeterministico.start(tape2, automato)
      test3 = AutomatoNaoDeterministico.start(tape3, automato)
      test4 = AutomatoNaoDeterministico.start(tape4, automato)
      assert test0 == false
      assert test1 == false
      assert test2 == true
      assert test3 == false
      assert test4 == false
    end

    test "complex" do
      transitions = [
        %{
          from_state: "q0",
          symbol: ?1,
          to_state: "q1"
        },
        %{
          from_state: "q1",
          symbol: ?0,
          to_state: "q0"
        },
        %{
          from_state: "q1",
          symbol: ?0,
          to_state: "q2"
        },
        %{
          from_state: "q1",
          symbol: ?1,
          to_state: "q2"
        }
      ]
      automato = %Automato.Finito{
        states: ["q0", "q1", "q2", "q3"],
        transitions: transitions,
        initial_state: "q0",
        accepting_states: ["q0"]
      }
      tape0 = ReadOnlyTape.init([])
      tape1 = ReadOnlyTape.init([?1, ?1])
      tape2 = ReadOnlyTape.init([?1, ?0])
      tape3 = ReadOnlyTape.init([?1, ?0, ?0])
      tape4 = ReadOnlyTape.init([?1, ?0, ?1])
      tape5 = ReadOnlyTape.init([?1, ?0, ?1, ?0])
      tape6 = ReadOnlyTape.init([?1, ?0, ?1, ?1])
      test0 = AutomatoNaoDeterministico.start(tape0, automato)
      test1 = AutomatoNaoDeterministico.start(tape1, automato)
      test2 = AutomatoNaoDeterministico.start(tape2, automato)
      test3 = AutomatoNaoDeterministico.start(tape3, automato)
      test4 = AutomatoNaoDeterministico.start(tape4, automato)
      test5 = AutomatoNaoDeterministico.start(tape5, automato)
      test6 = AutomatoNaoDeterministico.start(tape6, automato)
      assert test0 == true
      assert test1 == false
      assert test2 == true
      assert test3 == false
      assert test4 == false
      assert test5 == true
      assert test6 == false
    end

    test "empty transition" do
      transitions = [
        %{
          from_state: "q0",
          symbol: ?a,
          to_state: "q1"
        },
        %{
          from_state: "q1",
          symbol: ?b,
          to_state: "q2"
        },
        %{
          from_state: "q2",
          symbol: ?\0,
          to_state: "q3"
        },
        %{
          from_state: "q3",
          symbol: ?\0,
          to_state: "q0"
        }
      ]
      automato = %Automato.Finito{
        states: ["q0", "q1", "q2", "q3"],
        transitions: transitions,
        initial_state: "q0",
        accepting_states: ["q2"]
      }
      tape0 = ReadOnlyTape.init([])
      tape1 = ReadOnlyTape.init([?a, ?b])
      tape2 = ReadOnlyTape.init([?a, ?b, ?b])
      tape3 = ReadOnlyTape.init([?a, ?b, ?a, ?b])
      test0 = AutomatoNaoDeterministico.start(tape0, automato)
      test1 = AutomatoNaoDeterministico.start(tape1, automato)
      test2 = AutomatoNaoDeterministico.start(tape2, automato)
      test3 = AutomatoNaoDeterministico.start(tape3, automato)
      assert test0 == false
      assert test1 == true
      assert test2 == false
      assert test3 == true
    end
  end

  describe "AutomatoPilha" do
    test "simple" do
      transitions = [
        %{
          from_state: "q0",
          input_symbol: ?\0,
          pop_symbol: ?\0,
          push_symbol: '',
          to_state: "q1"
        },
        %{
          from_state: "q1",
          input_symbol: ?a,
          pop_symbol: ?\0,
          push_symbol: 'a',
          to_state: "q1"
        },
        %{
          from_state: "q1",
          input_symbol: ?b,
          pop_symbol: ?a,
          push_symbol: '',
          to_state: "q2"
        },
        %{
          from_state: "q2",
          input_symbol: ?b,
          pop_symbol: ?a,
          push_symbol: '',
          to_state: "q2"
        },
        %{
          from_state: "q2",
          input_symbol: ?\0,
          pop_symbol: ?$,
          push_symbol: '$',
          to_state: "q3"
        },
      ]
      automato = %Automato.Pilha{
        states: ["q0", "q1", "q2", "q3"],
        transitions: transitions,
        initial_state: "q0",
        accepting_states: ["q0", "q3"]
      }
      tape0 = TapeWithStack.init('', '$')
      tape1 = TapeWithStack.init('abb', '$')
      tape2 = TapeWithStack.init('aaabb', '$')
      tape3 = TapeWithStack.init('aaabbb', '$')
      test0 = AutomatoNaoDeterministico.start(tape0, automato)
      test1 = AutomatoNaoDeterministico.start(tape1, automato)
      test2 = AutomatoNaoDeterministico.start(tape2, automato)
      test3 = AutomatoNaoDeterministico.start(tape3, automato)
      assert test0 == true
      assert test1 == false
      assert test2 == false
      assert test3 == true
    end

    test "complex" do
      transitions = [
        %{
          from_state: "q1",
          input_symbol: ?a,
          pop_symbol: ?$,
          push_symbol: '00$',
          to_state: "q1"
        },
        %{
          from_state: "q1",
          input_symbol: ?a,
          pop_symbol: ?0,
          push_symbol: '000',
          to_state: "q1"
        },
        %{
          from_state: "q1",
          input_symbol: ?a,
          pop_symbol: ?1,
          push_symbol: '0',
          to_state: "q1"
        },
        %{
          from_state: "q1",
          input_symbol: ?a,
          pop_symbol: ?2,
          push_symbol: '',
          to_state: "q1"
        },
        %{
          from_state: "q1",
          input_symbol: ?b,
          pop_symbol: ?$,
          push_symbol: '1$',
          to_state: "q1"
        },
        %{
          from_state: "q1",
          input_symbol: ?b,
          pop_symbol: ?0,
          push_symbol: '',
          to_state: "q1"
        },
        %{
          from_state: "q1",
          input_symbol: ?b,
          pop_symbol: ?1,
          push_symbol: '2',
          to_state: "q1"
        },
        %{
          from_state: "q1",
          input_symbol: ?b,
          pop_symbol: ?2,
          push_symbol: '12',
          to_state: "q1"
        },
        %{
          from_state: "q1",
          input_symbol: ?\0,
          pop_symbol: ?$,
          push_symbol: '$',
          to_state: "q2"
        },
      ]
      automato = %Automato.Pilha{
        states: ["q1", "q2"],
        transitions: transitions,
        initial_state: "q1",
        accepting_states: ["q2"]
      }
      tape0 = TapeWithStack.init('', '$')
      tape1 = TapeWithStack.init('abb', '$')
      tape2 = TapeWithStack.init('aaabb', '$')
      tape3 = TapeWithStack.init('ababab', '$')
      tape4 = TapeWithStack.init('baabbbabb', '$')
      test0 = AutomatoNaoDeterministico.start(tape0, automato)
      test1 = AutomatoNaoDeterministico.start(tape1, automato)
      test2 = AutomatoNaoDeterministico.start(tape2, automato)
      test3 = AutomatoNaoDeterministico.start(tape3, automato)
      test4 = AutomatoNaoDeterministico.start(tape4, automato)
      assert test0 == true
      assert test1 == true
      assert test2 == false
      assert test3 == false
      assert test4 == true
    end
  end
end
