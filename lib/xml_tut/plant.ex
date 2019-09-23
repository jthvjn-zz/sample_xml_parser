defmodule Xmltut.Plant do

  use Ecto.Schema

  schema "plants" do
    field(:common, :string, default: "")
    field(:botanical, :string, default: "")
    field(:zone, :string, default: "")
    field(:light, :string, default: "")
    field(:price, :string, default: "")
    field(:availability, :string, default: "")
  end
end
