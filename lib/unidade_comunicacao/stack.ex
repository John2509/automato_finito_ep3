defmodule Stack do
  @type t :: %Stack{
    S: charlist,
  }
	defstruct [S: []]

  @spec show(t) :: charlist
  def show(%{S: s}) do
    s
  end

  @spec init(charlist) :: t
  def init(list) do
    %Stack{
      S: list
    }
  end

  @spec push(t, charlist) :: t
  def push(%{S: s}, list) do
    %Stack{
      S: list ++ s
    }
  end

  @spec pop(t) :: %{elem: char, stack: t}
  def pop(%{S: []}) do
    %{
      elem: ?\0,
      stack: %Stack{
        S: []
      }
    }
  end
  def pop(%{S: [head | tail]}) do
    %{
      elem: head,
      stack: %Stack{
        S: tail
      }
    }
  end

end
