namespace :exchange_rates do
  desc "Imports historical USD/EUR exchange rates"
  task import: :environment do
    puts "Importing exchange rates..."

    ExchangeRate::Importer.new.import

    puts "Importing exchange rates finished"
  end
end