require 'rails_helper'

describe ExchangeRate::Importer do
  let(:subject) { described_class.new }
  let(:rates_file) { File.open(Rails.root.join("spec", "fixtures", "exchange_rates.csv")) }
  let!(:existing_rates) { FactoryGirl.create_list(:exchange_rate, 5) }

  describe "#import" do
    context "when an error occurs during the import" do
      before do
        expect_any_instance_of(
          ExchangeRate::FileDownloader
        ).to receive(:download).once.and_raise(ExchangeRate::FileDownloader::FileDownloadError)
      end

      it "reraises the error and does not change the database state" do
        begin
          expect { subject.import }.not_to change { ExchangeRate.count }

          error_raised = false
        rescue StandardError => e
          error_raised = true
        ensure
          expect(error_raised).to eq(true)
        end
      end
    end

    context "when no error occurs" do
      before do
        expect_any_instance_of(
          ExchangeRate::FileDownloader
        ).to receive(:download).once.and_yield(rates_file)
      end

      it "substitutes the old records with new ones" do
        expect { subject.import }.to change { ExchangeRate.count }.by(4 - existing_rates.length)
      end

      it "does not import rows with invalid values" do
        subject.import

        expect(ExchangeRate.where(date: '2016-04-30').count).to eq(0)
      end
    end
  end
end