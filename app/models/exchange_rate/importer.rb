require 'csv'

class ExchangeRate
  class Importer
    def import
      ActiveRecord::Base.transaction do
        ExchangeRate.delete_all

        process_file
      end
    end

    private

    def process_file
      FileDownloader.new.download do |file|
        CSV.foreach(file.path) do |row|
          create_record(row)
        end
      end
    end

    def create_record(row)
      begin
        date = Date.parse(row[0])
      rescue ArgumentError, TypeError
        return
      end

      begin
        eur_value = Float(row[1])
      rescue ArgumentError, TypeError
        return
      end

      ExchangeRate.create!(date: date, eur_value: eur_value)
    end
  end
end