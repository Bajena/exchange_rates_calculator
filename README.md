# README

* install ruby 2.2.2
* run ```bundle``` to download dependencies
* run ```rake exchange_rates:import``` to import current exchange rate values
* run ```rails c```
* call ```ExchangeRate::Converter.convert(15.0, '2016-05-15')```
 => 85.98 
