# Xmltut - a SAX parser for plant_catalog.xml (Example from w3cSchools)

To verify the parsing:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start IEx with phoenix server with `iex -S mix phx.server`
  * Run GenServer.call(:plant_cataloger, {:start_parsing, "plant_catalog.xml"})
  * Check the database 'xmltut_dev' for table 'plants' to verify the data is parsed and inserted
