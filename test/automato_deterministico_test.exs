defmodule AutomatoDeterministicoTest do
  use ExUnit.Case
  doctest AutomatoDeterministico

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
          symbol: ?b,
          to_state: "q1"
        },
        %{
          from_state: "q1",
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
          symbol: ?a,
          to_state: "q2"
        },
        %{
          from_state: "q2",
          symbol: ?b,
          to_state: "q2"
        },
      ]
      automato = %Automato.Finito{
        states: ["q0", "q1", "q2"],
        transitions: transitions,
        initial_state: "q0",
        accepting_states: ["q1"]
      }
      tape = ReadOnlyTape.init([?a, ?a])
      test = AutomatoDeterministico.start(tape, automato)
      assert test == true
    end

    test "complex" do
      transitions = [
        %{
          from_state: "A",
          symbol: ?a,
          to_state: "B"
        },
        %{
          from_state: "A",
          symbol: ?b,
          to_state: "D"
        },
        %{
          from_state: "A",
          symbol: ?c,
          to_state: "D"
        },
        %{
          from_state: "B",
          symbol: ?a,
          to_state: "B"
        },
        %{
          from_state: "B",
          symbol: ?b,
          to_state: "B"
        },
        %{
          from_state: "B",
          symbol: ?c,
          to_state: "C"
        },
        %{
          from_state: "C",
          symbol: ?b,
          to_state: "C"
        },
        %{
          from_state: "C",
          symbol: ?c,
          to_state: "C"
        },
        %{
          from_state: "C",
          symbol: ?a,
          to_state: "D"
        },
        %{
          from_state: "D",
          symbol: ?a,
          to_state: "D"
        },
        %{
          from_state: "D",
          symbol: ?b,
          to_state: "D"
        },
        %{
          from_state: "D",
          symbol: ?c,
          to_state: "D"
        }
      ]
      automato = %Automato.Finito{
        states: ["A", "B", "C", "D"],
        transitions: transitions,
        initial_state: "A",
        accepting_states: ["B", "C"]
      }
      tape0  = ReadOnlyTape.init([])
      tape1  = ReadOnlyTape.init([?a])
      tape2  = ReadOnlyTape.init([?b])
      tape3  = ReadOnlyTape.init([?c])
      tape4  = ReadOnlyTape.init([?a, ?a])
      tape5  = ReadOnlyTape.init([?a, ?b])
      tape6  = ReadOnlyTape.init([?b, ?a])
      tape7  = ReadOnlyTape.init([?a, ?a, ?a])
      tape8  = ReadOnlyTape.init([?a, ?b, ?c])
      tape9  = ReadOnlyTape.init([?b, ?c, ?b])
      tape10 = ReadOnlyTape.init([?a, ?a, ?b, ?b, ?c, ?c])
      tape11 = ReadOnlyTape.init([?a, ?a, ?a, ?a, ?c, ?c])
      tape12 = ReadOnlyTape.init([?a, ?a, ?c, ?c, ?b, ?b])
      tape13 = ReadOnlyTape.init([?b, ?c, ?c, ?c, ?b, ?b])
      test0  = AutomatoDeterministico.start(tape0, automato)
      test1  = AutomatoDeterministico.start(tape1, automato)
      test2  = AutomatoDeterministico.start(tape2, automato)
      test3  = AutomatoDeterministico.start(tape3, automato)
      test4  = AutomatoDeterministico.start(tape4, automato)
      test5  = AutomatoDeterministico.start(tape5, automato)
      test6  = AutomatoDeterministico.start(tape6, automato)
      test7  = AutomatoDeterministico.start(tape7, automato)
      test8  = AutomatoDeterministico.start(tape8, automato)
      test9  = AutomatoDeterministico.start(tape9, automato)
      test10 = AutomatoDeterministico.start(tape10, automato)
      test11 = AutomatoDeterministico.start(tape11, automato)
      test12 = AutomatoDeterministico.start(tape12, automato)
      test13 = AutomatoDeterministico.start(tape13, automato)
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
  end

end
