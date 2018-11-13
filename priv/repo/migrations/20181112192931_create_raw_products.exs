defmodule Fido.Repo.Migrations.CreateRawProducts do
  use Ecto.Migration

  def change do
    create table(:raw_product) do
      add :url, :string, null: false
      add :body, :text, null: false
    end

    create unique_index(:raw_product, :url)
  end
end
