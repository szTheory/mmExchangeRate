# MmExchangeRate

A simple exchange rate checker and calculator based on [Central Bank of Myanmar Api](http://forex.cbm.gov.mm/index.php/api) in elixir. You can find [it](https://hex.pm/packages/mmExchangeRate) on hex.

Before you try it, make sure you've install [elixir 1.*](http://elixir-lang.org/install.html)
In mix.exs,

```elixir
defp deps do
  [
    {:ibrowse, github: "cmullaparthi/ibrowse", tag: "v4.1.0"},
    {:mmExchangeRate, "~> 0.0.1"}
  ]
end
```


##### To check available currency list

```elixir
MmExchangeRate.currencies()
```

##### To check today exchange rate

```elixir
MmExchangeRate.today("usd") # default currency is usd if paramter is empty
```

##### To calculate rate with today exchange rate

```elixir
MmExchangeRate.calculate(100, "usd") # default currency is usd if paramter is empty
```

##### To check exchange rate history

```elixir
MmExchangeRate.from("dd-mm-yyyy", "usd") # default currency is usd if paramter is empty	
```

