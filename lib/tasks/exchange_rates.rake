namespace :exchange_rates do
  desc "Imports historical USD/EUR exchange rates"
  task import: :environment do
    puts "Importing exchange rates..."
  end
end