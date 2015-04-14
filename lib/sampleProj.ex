defmodule SampleProj do

	use HTTPotion.Base

  def get_currencies() do
    currencies = Enum.map MmExchangeRate.currencies(), fn ({k, v}) -> to_string(k) <> " (" <> to_string(v) <> ")\n" end
    EEx.eval_string "Available currency list are \n <%= currencies %>", [currencies: currencies]
  end

	def get_today(currency \\ "USD") do
    rate = MmExchangeRate.today(currency)
    currency = currency |> String.upcase()
		EEx.eval_string "1 KS is equal with <%= rate %> <%= currency %> today", [rate: rate, currency: currency]
	end

  def get_from(date, currency \\ "USD") do 
    rate = MmExchangeRate.from(date, currency)
    EEx.eval_string "1 KS was equal with <%= rate %> <%= currency %> in <%= date %>", [rate: rate, currency: currency, date: date]
  end

  def get_calculation(kyat, currency  \\ "USD") do
    total = MmExchangeRate.calculate(kyat, currency)
    currency = currency |> String.upcase()
    EEx.eval_string "<%= kyat %> KS is equal with <%= total %> <%= currency %> ", [kyat: kyat, total: total, currency: currency]
  end

end

