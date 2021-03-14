defmodule ReadOnlyTape do
  @type t :: %ReadOnlyTape{
    T: Tape.t,
  }
	defstruct [T: Tape.init([])]

  @spec show(t) :: charlist
  def show(%{T: tape}) do
    Tape.show(tape)
  end

  @spec read(t) :: char
  def read(%{T: tape}) do
    Tape.read(tape)
  end

  @spec init(charlist) :: t
  def init(text) do
    %ReadOnlyTape{
      T: Tape.init(text)
    }
  end

  @spec reconfig(t) :: t
  def reconfig(%{T: tape}) do
    %ReadOnlyTape{
      T: Tape.right(tape)
    }
  end

end
