defmodule MmExchangeRate do

  use HTTPotion.Base

  def process_url(url) do
    "http://forex.cbm.gov.mm/api/" <> url     
  end

  def process_request_headers(headers) do
    Dict.put headers, :"User-Agent", "mmexr-potion"
  end

  def process_response_body(body) do
      json = :jsx.decode(to_string(body), [{:labels, :binary}])
      Enum.map json, fn ({k, v}) -> { String.to_atom(k), v } end
    end

  @doc """
    Get available currency list
    """
    def currencies() do
      json = get("currencies")
      Enum.map json.body[:currencies], fn ({k, v}) -> {String.to_atom(k), String.to_atom(v)}  end
    end

    @doc """
    Get today exchange rate by user selected currency
    """
    def today(currency \\ "USD") when is_binary currency do
      rates = get_rate("latest")
      rates[currency |> String.upcase() |> String.to_atom()]
    end

    @doc """
    Get exchange rate by user selected currency in selected date
    """
    def from(date, currency \\ "USD") when is_binary date and is_binary currency do 
      rates = get_rate("history/" <> date)
      rates[currency |> String.upcase() |> String.to_atom()]
  end

  @doc """
    Calculate today exchange rate by user selected currency
    """
    def calculate(kyat, currency  \\ "USD") when is_integer kyat and is_binary currency do
      rates = get_rate("latest")
      rate = rates[currency |> String.upcase() |> String.to_atom()] |> to_string()
      if String.contains? rate, "," do
        rate = String.replace(rate, ",", "")
      end 
      Float.to_char_list(kyat * (rate |> String.to_float()), [decimals: 1])
  end

  defp get_rate(uri) do   
    json = get(uri)
    rate = Enum.map json.body[:rates], fn ({k, v}) -> { String.to_atom(k), String.to_atom(v) } end
  end
end

