defmodule Tape do
  @type t :: %Tape{
    L: charlist,
    R: charlist
  }
	defstruct [L: [], R: []]

  @spec show(t) :: charlist
  def show(%{L: l, R: r}) do
    Enum.reverse(l) ++ r
  end

  @spec read(t) :: char
  def read(%{R: []}), do: ?\s
  def read(%{R: [head | _tail]}) do
    head
  end

  @spec init(charlist) :: t
  def init(text) do
    %Tape{
      L: [],
      R: text
    }
  end

  @spec write(t, char) :: t
  def write(%{L: l, R: []}, symbol) do
    %Tape{
      L: l,
      R: [symbol]
    }
  end
  def write(%{L: l, R: [_head | tail]}, symbol) do
    %Tape{
      L: l,
      R: [symbol | tail]
    }
  end

  @spec left(t) :: t
  def left(%{L: [], R: r}) do
    %Tape{
      L: [],
      R: ' ' ++ r
    }
  end
  def left(%{L: [head | tail], R: r}) do
    %Tape{
      L: tail,
      R: [head | r]
    }
  end

  @spec right(t) :: t
  def right(%{L: l, R: []}) do
    %Tape{
      L: ' ' ++ l,
      R: []
    }
  end
  def right(%{L: l, R: [head | tail]}) do
    %Tape{
      L: [head | l],
      R: tail
    }
  end

end
