class ExchangeRate
  class FileDownloader
    class FileDownloadError < StandardError; end

    def download
      file = File.new(DESTINATION_FILEPATH, 'w')
      file.write(fetch_exchange_rates)

      yield file

      File.unlink(file)
    rescue RestClient::Exception => e
      Rails.logger.error "Fetching rates file failed: #{e}"
      raise FileDownloadError
    end

    private

    EXCHANGE_RATES_FILE_URL = "http://sdw.ecb.europa.eu/export.do?type=&trans=N&node=2018794&CURRENCY=USD&FREQ=D&start=01-01-2012&q=&submitOptions.y=6&submitOptions.x=51&sfl1=4&end=&SERIES_KEY=120.EXR.D.USD.EUR.SP00.A&sfl3=4&DATASET=0&exportType=csv"

    DESTINATION_FILEPATH = "tmp/exchange_rates.csv"

    def fetch_exchange_rates
      RestClient.get(EXCHANGE_RATES_FILE_URL).to_str
    end
  end
end