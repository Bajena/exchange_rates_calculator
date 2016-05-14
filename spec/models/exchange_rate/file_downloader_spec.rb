require 'rails_helper'

describe ExchangeRate::FileDownloader do
  let(:subject) { described_class.new }
  let(:rates_file_path) { Rails.root.join("spec", "fixtures", "exchange_rates.csv") }

  describe "#download" do
    context "when exchange rates request succeeds" do
      let(:response_double) { double(to_str: File.read(rates_file_path)) }

      before do
        expect(RestClient).to receive(:get) { response_double }
      end

      it "yields a downloaded file instance" do
        subject.download do |file|
          expect(file.size).to eq(rates_file_path.size)
        end
      end

      it "destroys the downloaded file after yielding" do
        path = nil
        subject.download do |file|
          path = file.path
        end

        expect(File.exists?(path)).to eq(false)
      end
    end

    context "when exchange rates request fails" do
      before do
        expect(RestClient).to receive(:get).and_raise(RestClient::Exception)
      end

      it "raises FileDownloadError" do
        expect { subject.download }.to raise_error(ExchangeRate::FileDownloader::FileDownloadError)
      end
    end
  end
end