defmodule MmExchangeRate do
	use MmExchangeRate.HttpWrapper

	@doc """
  	Get available currency list
  	"""
  	def currencies() do
  		json = get("currencies")
  		currencies = Enum.map json.body[:currencies], fn ({k, v}) -> k <> " (" <> v <> ")\n" end
  		currencies = currencies |> List.to_string()	
  		EEx.eval_string "Available currency list are \n <%= currencies %>", [currencies: currencies]
  	end

  	@doc """
  	Get today exchange rate by user selected currency
  	"""
  	def today(currency \\ "USD") when is_binary currency do
  		rates = get_rate("latest")
  		currency = currency |> String.upcase()
		rate = rates[currency |> String.to_atom()]
		EEx.eval_string "1 KS is equal with <%= rate %> <%= currency %> today", [rate: rate, currency: currency]
  	end

  	@doc """
  	Get exchange rate by user selected currency in selected date
  	"""
  	def from(date, currency \\ "USD") when is_binary date and is_binary currency do 
		rates = get_rate("history/" <> date)
		currency = currency |> String.upcase()
  		rate = rates[currency |> String.to_atom()]
  		EEx.eval_string "1 KS was equal with <%= rate %> <%= currency %> in <%= date %>", [rate: rate, currency: currency, date: date]
	end

	@doc """
  	Calculate today exchange rate by user selected currency
  	"""
  	def calculate(kyat, currency  \\ "USD") when is_binary kyat and is_binary currency do
		rates = get_rate("latest")
		currency = currency |> String.upcase()
		rate = rates[currency |> String.to_atom()]
  		if String.contains? rate, "," do
  			rate = String.replace(rate, ",", "")
  		end	
  		total = kyat * (rate |> String.to_float())  		
  		EEx.eval_string "<%= kyat %> KS is equal with <%= total %> <%= currency %> ", [kyat: kyat, total: total, currency: currency]
	end

	defp get_rate(uri) do		
		json = get(uri)
  		rate = Enum.map json.body[:rates], fn ({k, v}) -> { String.to_atom(k), v } end
	end
end

defmodule MmExchangeRate.HttpWrapper do
	use HTTPotion.Base

	def process_url(url) do
		"http://forex.cbm.gov.mm/api/" <> url			
	end

	def process_request_headers(headers) do
		Dict.put headers, :"User-Agent", "mmexr-potion"
	end

	def process_response_body(body) do
    	json = :jsx.decode(to_string(body), [{:labels, :binary}])
    	json2 = Enum.map json, fn ({k, v}) -> { String.to_atom(k), v } end
  	end
end
