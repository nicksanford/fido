defmodule Fido.Queue do
  use GenServer

  # TODO: As a potential optimization, you could keep a set as well as a queue
  # in order to ensure that we never enqueue an element which is already present
  # You would add elements to the set when you add the to the queue (checking first
  # that the new element is not already present in the set) and remove elements
  # from the set when an element is removed from the queue.
  def start_link(name) do
    GenServer.start_link(__MODULE__, :queue.new(), name: name)
  end

  def enqueue(name, element) do
    GenServer.call(name, {:in, element})
  end

  def dequeue(name) do
    GenServer.call(name, :out)
  end

  @impl true
  def init(queue) do
    {:ok, queue}
  end

  @impl true
  def handle_call({:in, element}, _from, queue) do
    {:reply, :ok, :queue.in(element, queue)}
  end

  @impl true
  def handle_call(:out, _from, queue) do
    case :queue.out(queue) do
      {:empty, empty_queue} ->
         {:reply, nil, empty_queue}
      {{:value, element}, queue} ->
         {:reply, {:ok, element}, queue}
    end
  end
end
