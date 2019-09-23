defmodule Xmltut.PlantCatalogEventHandler do
  @behaviour Saxy.Handler

  use GenServer

  def start_link([]) do
    GenServer.start_link(__MODULE__, [], name: :plant_cataloger)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast({:start_parsing, document}, _state) do
    with {:ok, xml} <- File.read(document) do
      state = :ets.new(:plant_catalog, [:set, :named_table, :protected, read_concurrency: true])
      :ets.new(:plant, [:set, :named_table, :protected, read_concurrency: true])

      xml
      |>  Saxy.parse_string(__MODULE__, state)

      {:noreply, state}
    end
  end

  def handle_cast(_, state) do
    IO.inspect  "Unhandled event"
    {:noreply, state}
  end

  @impl true
  def handle_call(_, _, state) do
    {:reply, "Unhandled event", state}
  end

  @impl true
  def handle_info(_, state) do
    IO.inspect  "Unhandled event"
    {:noreply, state}
  end

  @impl true
  def handle_event(:start_document, _prolog, state) do
    IO.inspect("Started parsing document")
    {:ok, state}
  end

  def handle_event(:end_document, _data, state) do
    IO.inspect("Finish parsing document")
    [{"PLANTS", plants}] = :ets.lookup(:plant_catalog, "PLANTS")
    Xmltut.Repo.insert_all(Xmltut.Plant, plants)

    {:ok,  state}
  end

  def handle_event(:start_element, {tag_name, attributes}, state) do
    IO.inspect("Start parsing element #{tag_name} with attributes #{inspect(attributes)}")

    if tag_name == "PLANT" do
        plant =
          %Xmltut.Plant{}
          |> Map.from_struct
          |> Map.delete(:id)
          |> Map.delete(:__meta__)

        :ets.insert(:plant, {"PLANT", plant})
    end

    {:ok, {tag_name, state}}
  end

  def handle_event(:end_element, name, state) do
    IO.inspect("Finished parsing element #{name}")

    if name == "PLANT" do
        record = :ets.lookup(:plant_catalog, "PLANTS")
        plants =
          if length(record) == 0 do
            []
          else
            [{"PLANTS", plants }] = record
            plants
          end

        [{"PLANT", current_plant }] = :ets.lookup(:plant, "PLANT")
        :ets.insert(:plant_catalog, {"PLANTS", [current_plant | plants]})
    end

    {:ok,  state}
  end

  def handle_event(:characters, chars, {current_tag, state}) do
    IO.inspect("Receive characters #{chars}")

    [{ "PLANT", current_plant  }] = :ets.lookup(:plant, "PLANT")


    current_plant =
      case current_tag do
        "COMMON"        ->
          Map.put(current_plant, :common, chars)
        "BOTANICAL"     ->
          Map.put(current_plant, :botanical, chars)
        "ZONE"          ->
          Map.put(current_plant, :zone, chars)
        "LIGHT"         ->
          Map.put(current_plant, :light, chars)
        "PRICE"         ->
          Map.put(current_plant, :price, chars)
        "AVAILABILITY"  ->
          Map.put(current_plant, :availability, chars)

        _ ->
          current_plant
      end

      :ets.insert(:plant, {"PLANT", current_plant})

    {:ok, {current_tag, state}}
  end
end



