defmodule TapeWithStack do
  @type t :: %TapeWithStack{
    T: ReadOnlyTape.t,
    S: Stack.t,
  }
	defstruct [T: ReadOnlyTape.init([]), S: Stack.init([])]

  @spec show(t) :: %{tape: charlist, stack: charlist}
  def show(%{T: t, S: s}) do
    %{
      tape: ReadOnlyTape.show(t),
      stack: Stack.show(s)
    }
  end

  @spec read(t) :: %{tape_elem: char, stack_elem: char, tape_with_stack: t}
  def read(%{T: t, S: s}) do
    %{elem: elem, stack: new_stack} = Stack.pop(s);
    %{
      tape_elem: ReadOnlyTape.read(t),
      stack_elem: elem,
      tape_with_stack: %TapeWithStack{
        T: t,
        S: new_stack
      }
    }
  end

  @spec init(charlist, charlist) :: t
  def init(tape, stack) do
    %TapeWithStack{
      T: ReadOnlyTape.init(tape),
      S: Stack.init(stack)
    }
  end

  @spec reconfig(t, boolean, charlist) :: t
  def reconfig(%{T: t, S: s}, move, toPush) do
    %TapeWithStack{
      T: if(move , do: ReadOnlyTape.reconfig(t), else: t),
      S: Stack.push(s, toPush)
    }
  end

end
