defmodule Fido do
  import SweetXml
  require Logger
  @sitemap "https://www.sephora.com/products-sitemap.xml"

  @moduledoc """
  Documentation for Fido.
  """

  @doc """
  """
  def products do
    # TODO: The sitemap could live in a starter url table
    # TODO: SweetXml appears to be a very slow parser, consider using floki
    # if performance becomes an issue: https://github.com/philss/floki
    %HTTPoison.Response{status_code: 200, body: body} = HTTPoison.get!(@sitemap)

    maybe_to_download =
      xpath(body, ~x"///urlset/url/loc/text()"l)
      |> Enum.map(&List.to_string/1)
      |> MapSet.new()

    already_downloaded =
      Fido.RawProduct.q_raw_product_urls()
      |> Fido.Repo.all()
      |> MapSet.new()

    MapSet.difference(maybe_to_download, already_downloaded) |> MapSet.to_list()
  end

  def enqueue_products do
    products()
    |> Enum.map(fn url -> Fido.Queue.enqueue(Fido.RawProduct, %{url: url}) end)
  end
end
