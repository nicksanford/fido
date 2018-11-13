defmodule Fido.RawProduct do
  use Ecto.Schema

  import Ecto.Query
  import Ecto.Changeset

  alias Fido.RawProduct

  schema "raw_product" do
    field :url, :string, null: false
    field :body, :string, null: false
  end

  def changeset(raw_product, params \\ %{} ) do
    raw_product
    |> cast(params, [:url, :body])
    |> validate_required([:url, :body])
    |> unique_constraint(:url)
  end

  def q_raw_product_urls do
    from rp in RawProduct,
    select: rp.url
  end
end
