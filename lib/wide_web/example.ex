defmodule WideWeb.Example do
  alias WideWeb.Router
  @sweden :"sweden@127.0.0.1"
  @italy :"italy@127.0.0.1"

  def build_sweden do
    Router.start(:stockholm)
    Router.start(:goteborg)
    Router.start(:malmo)
    Router.start(:lund)

    connect(:stockholm, :goteborg, @sweden)
    connect(:stockholm, :malmo, @sweden)
    connect(:malmo, :lund, @sweden)
  end

  def build_italy do
    Router.start(:rome)
    Router.start(:milan)
    Router.start(:turin)

    connect(:rome, :milan, @italy)
    connect(:milan, :turin, @italy)
  end

  def connect(first, second, country), do: connect({first, country}, {second, country})
  def connect({first_name, _} = first, {second_name, _} = second) do
    send(first, {:add, second_name, second})
    send(second, {:add, first_name, first})
  end

  def connect_sweden_and_italy  do
    connect({:stockholm, @sweden}, {:rome, @italy})
    connect({:goteborg, @sweden}, {:milan, @italy})
  end

  def send_greeting do
    send({:malmo, @sweden}, {:send, :turin, "Hej fran Sveridge"})
  end

  def status(node) do
    send(node, {:status, self()})
    receive do
      {:status, status} -> status
    end
  end
end
