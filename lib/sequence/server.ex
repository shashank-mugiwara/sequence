defmodule Sequence.Server do
  use GenServer

  @me __MODULE__

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: @me)
  end

  def next_number do
    GenServer.call(@me, {:increment_by_one})
  end

  def add_number(delta) do
    GenServer.cast(@me, {:add_to_number, delta})
  end

  def init(_) do
    {:ok, Sequence.Stash.get()}
  end

  def handle_call({:increment_by_one}, _from, current_number) do
    {:reply, current_number, current_number + 1}
  end

  def handle_cast({:add_to_number, delta}, current_number) do
    {:noreply, current_number + delta}
  end

  def terminate(_reason, current_number) do
    Sequence.Stash.update(current_number)
  end
end
