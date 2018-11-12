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
    xpath(body, ~x"///urlset/url/loc/text()"l)
    # Query ecto table for products, if one already exists, filter it out from the spawn list
    # Enque this list into the work queue
    # Ecto add these to a table
  end
end
