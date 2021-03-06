defmodule AutomatoTest do
  use ExUnit.Case
  doctest Automato

  describe "AutomatoFinito" do
    test "simple det" do
      transitions = [
        %{
          from_state: "q0",
          input_symbol: ?a,
          to_state: "q1"
        },
        %{
          from_state: "q0",
          input_symbol: ?b,
          to_state: "q1"
        },
        %{
          from_state: "q1",
          input_symbol: ?a,
          to_state: "q1"
        },
        %{
          from_state: "q1",
          input_symbol: ?b,
          to_state: "q2"
        },
        %{
          from_state: "q2",
          input_symbol: ?a,
          to_state: "q2"
        },
        %{
          from_state: "q2",
          input_symbol: ?b,
          to_state: "q2"
        },
      ]
      automato = %Automato.Finito{
        states: ["q0", "q1", "q2"],
        transitions: transitions,
        initial_state: "q0",
        accepting_states: ["q1"]
      }
      tape0 = ReadOnlyTape.init('aa')
      tape1 = ReadOnlyTape.init('ab')
      tape2 = ReadOnlyTape.init('ba')
      test0 = Automato.start(tape0, automato)
      test1 = Automato.start(tape1, automato)
      test2 = Automato.start(tape2, automato)
      assert test0 == true
      assert test1 == false
      assert test2 == true
    end

    test "complex det" do
      transitions = [
        %{
          from_state: "A",
          input_symbol: ?a,
          to_state: "B"
        },
        %{
          from_state: "A",
          input_symbol: ?b,
          to_state: "D"
        },
        %{
          from_state: "A",
          input_symbol: ?c,
          to_state: "D"
        },
        %{
          from_state: "B",
          input_symbol: ?a,
          to_state: "B"
        },
        %{
          from_state: "B",
          input_symbol: ?b,
          to_state: "B"
        },
        %{
          from_state: "B",
          input_symbol: ?c,
          to_state: "C"
        },
        %{
          from_state: "C",
          input_symbol: ?b,
          to_state: "C"
        },
        %{
          from_state: "C",
          input_symbol: ?c,
          to_state: "C"
        },
        %{
          from_state: "C",
          input_symbol: ?a,
          to_state: "D"
        },
        %{
          from_state: "D",
          input_symbol: ?a,
          to_state: "D"
        },
        %{
          from_state: "D",
          input_symbol: ?b,
          to_state: "D"
        },
        %{
          from_state: "D",
          input_symbol: ?c,
          to_state: "D"
        }
      ]
      automato = %Automato.Finito{
        states: ["A", "B", "C", "D"],
        transitions: transitions,
        initial_state: "A",
        accepting_states: ["B", "C"]
      }
      tape0  = ReadOnlyTape.init('')
      tape1  = ReadOnlyTape.init('a')
      tape2  = ReadOnlyTape.init('b')
      tape3  = ReadOnlyTape.init('c')
      tape4  = ReadOnlyTape.init('aa')
      tape5  = ReadOnlyTape.init('ab')
      tape6  = ReadOnlyTape.init('ba')
      tape7  = ReadOnlyTape.init('aaa')
      tape8  = ReadOnlyTape.init('abc')
      tape9  = ReadOnlyTape.init('bcb')
      tape10 = ReadOnlyTape.init('aabbcc')
      tape11 = ReadOnlyTape.init('aaaacc')
      tape12 = ReadOnlyTape.init('aaccbb')
      tape13 = ReadOnlyTape.init('bcccbb')
      test0  = Automato.start(tape0, automato)
      test1  = Automato.start(tape1, automato)
      test2  = Automato.start(tape2, automato)
      test3  = Automato.start(tape3, automato)
      test4  = Automato.start(tape4, automato)
      test5  = Automato.start(tape5, automato)
      test6  = Automato.start(tape6, automato)
      test7  = Automato.start(tape7, automato)
      test8  = Automato.start(tape8, automato)
      test9  = Automato.start(tape9, automato)
      test10 = Automato.start(tape10, automato)
      test11 = Automato.start(tape11, automato)
      test12 = Automato.start(tape12, automato)
      test13 = Automato.start(tape13, automato)
      assert test0 == false
      assert test1 == true
      assert test2 == false
      assert test3 == false
      assert test4 == true
      assert test5 == true
      assert test6 == false
      assert test7 == true
      assert test8 == true
      assert test9 == false
      assert test10 == true
      assert test11 == true
      assert test12 == true
      assert test13 == false
    end

    test "simple nao det" do
      transitions = [
        %{
          from_state: "q0",
          input_symbol: ?a,
          to_state: "q1"
        },
        %{
          from_state: "q0",
          input_symbol: ?a,
          to_state: "q3"
        },
        %{
          from_state: "q1",
          input_symbol: ?a,
          to_state: "q2"
        }
      ]
      automato = %Automato.Finito{
        states: ["q0", "q1", "q2", "q3"],
        transitions: transitions,
        initial_state: "q0",
        accepting_states: ["q2"]
      }
      tape0 = ReadOnlyTape.init('')
      tape1 = ReadOnlyTape.init('a')
      tape2 = ReadOnlyTape.init('aa')
      tape3 = ReadOnlyTape.init('aaa')
      tape4 = ReadOnlyTape.init('aaaa')
      test0 = Automato.start(tape0, automato)
      test1 = Automato.start(tape1, automato)
      test2 = Automato.start(tape2, automato)
      test3 = Automato.start(tape3, automato)
      test4 = Automato.start(tape4, automato)
      assert test0 == false
      assert test1 == false
      assert test2 == true
      assert test3 == false
      assert test4 == false
    end

    test "complex nao det" do
      transitions = [
        %{
          from_state: "q0",
          input_symbol: ?1,
          to_state: "q1"
        },
        %{
          from_state: "q1",
          input_symbol: ?0,
          to_state: "q0"
        },
        %{
          from_state: "q1",
          input_symbol: ?0,
          to_state: "q2"
        },
        %{
          from_state: "q1",
          input_symbol: ?1,
          to_state: "q2"
        }
      ]
      automato = %Automato.Finito{
        states: ["q0", "q1", "q2", "q3"],
        transitions: transitions,
        initial_state: "q0",
        accepting_states: ["q0"]
      }
      tape0 = ReadOnlyTape.init('')
      tape1 = ReadOnlyTape.init('11')
      tape2 = ReadOnlyTape.init('10')
      tape3 = ReadOnlyTape.init('100')
      tape4 = ReadOnlyTape.init('101')
      tape5 = ReadOnlyTape.init('1010')
      tape6 = ReadOnlyTape.init('1011')
      test0 = Automato.start(tape0, automato)
      test1 = Automato.start(tape1, automato)
      test2 = Automato.start(tape2, automato)
      test3 = Automato.start(tape3, automato)
      test4 = Automato.start(tape4, automato)
      test5 = Automato.start(tape5, automato)
      test6 = Automato.start(tape6, automato)
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
          input_symbol: ?a,
          to_state: "q1"
        },
        %{
          from_state: "q1",
          input_symbol: ?b,
          to_state: "q2"
        },
        %{
          from_state: "q2",
          input_symbol: ?\0,
          to_state: "q3"
        },
        %{
          from_state: "q3",
          input_symbol: ?\0,
          to_state: "q0"
        }
      ]
      automato = %Automato.Finito{
        states: ["q0", "q1", "q2", "q3"],
        transitions: transitions,
        initial_state: "q0",
        accepting_states: ["q2"]
      }
      tape0 = ReadOnlyTape.init('')
      tape1 = ReadOnlyTape.init('ab')
      tape2 = ReadOnlyTape.init('abb')
      tape3 = ReadOnlyTape.init('abab')
      test0 = Automato.start(tape0, automato)
      test1 = Automato.start(tape1, automato)
      test2 = Automato.start(tape2, automato)
      test3 = Automato.start(tape3, automato)
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
      test0 = Automato.start(tape0, automato)
      test1 = Automato.start(tape1, automato)
      test2 = Automato.start(tape2, automato)
      test3 = Automato.start(tape3, automato)
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
      test0 = Automato.start(tape0, automato)
      test1 = Automato.start(tape1, automato)
      test2 = Automato.start(tape2, automato)
      test3 = Automato.start(tape3, automato)
      test4 = Automato.start(tape4, automato)
      assert test0 == true
      assert test1 == true
      assert test2 == false
      assert test3 == false
      assert test4 == true
    end
  end

end
