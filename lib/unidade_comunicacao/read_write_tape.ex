defmodule ReadWriteTape do
  @type diretion :: :right | :left
  @type t :: %ReadWriteTape{
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
    %ReadWriteTape{
      T: Tape.init(text)
    }
  end

  @spec reconfig(t, char, diretion) :: t
  def reconfig(%{T: tape}, char, :right) do
    %ReadWriteTape{
      T: Tape.write(tape, char) |> Tape.right()
    }
  end
  def reconfig(%{T: tape}, char, :left) do
    %ReadWriteTape{
      T: Tape.write(tape, char) |> Tape.left()
    }
  end

end
