defmodule Fido.Runner do
  use GenServer

  require Logger

  alias Fido.Queue
  alias Fido.RawProduct

  @interval 500

  def execute(_job = %{url: url}) do
    # TODO put data access behind a context
    with nil <- Fido.Repo.get_by(RawProduct, url: url),
         {:ok, %HTTPoison.Response{status_code: 200, body: body}} <- HTTPoison.get(url)
    do
         params = %{url: url, body: body}
         RawProduct.changeset(%RawProduct{}, params)
         |> Fido.Repo.insert!()

         Logger.info("raw_product job for url: #{url} complete")
    else
      %RawProduct{id: id} ->
        Logger.warn("Pulled raw_product job for url: #{url} from work queue. However it already exists in row #{id}")
      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error("Http error for raw_product job for url: #{url} #{reason}")
      error ->
        Logger.error("Error for raw_product job for url: #{url} #{error}")
    end
  end

  def start_link(work_queue_name) do
    state = %{work_queue_name: work_queue_name}
    GenServer.start_link(__MODULE__, state, name: name(state))
  end

  @impl true
  def init(state) do
    Process.send_after(name(state), :pull_work, @interval)
    {:ok, state}
  end

  @impl true
  def handle_info(:pull_work, state = %{work_queue_name: work_queue_name}) do
    beginning_time = System.monotonic_time(:millisecond)

    # TODO: BEGIN This could be extracted out into its own work module using MFA
    # Pull work if there is work to do
    with {:ok, job} <- Queue.dequeue(work_queue_name), do: execute(job)

    # TODO: END

    end_time = System.monotonic_time(:millisecond)
    Process.send_after(name(state), :pull_work, pull_work_in(beginning_time, end_time))

    {:noreply, state}
  end

  def name(%{work_queue_name: work_queue_name}) do
    :"#{__MODULE__}_#{work_queue_name}"
  end

  def pull_work_in(beginning_time, end_time) do
    max(@interval - abs(beginning_time - end_time), 0)
  end
end
