defmodule Xmltut.Repo.Migrations.CreatePlants do
  use Ecto.Migration

  def change do
    create table(:plants) do
      add(:common, :string, default: "")
      add(:botanical, :string, default: "")
      add(:zone, :string, default: "")
      add(:light, :string, default: "")
      add(:price, :string, default: "")
      add(:availability, :string, default: "")
    end
  end
end
