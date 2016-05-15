require 'rails_helper'

describe ExchangeRate::Converter do
  describe "#convert" do
    context "when amount is < 0" do
      it "raises InvalidAmount error" do
        expect { described_class.convert(-0.01, '2016-05-15') }.to raise_error(ExchangeRate::Converter::InvalidAmount)
      end
    end

    context "when amount is not a number" do
      it "raises InvalidAmount error" do
        expect { described_class.convert('0.01', '2016-05-15') }.to raise_error(ExchangeRate::Converter::InvalidAmount)
      end
    end

    context "when date_string param is not a valid date" do
      it "raises InvalidDate error" do
        expect { described_class.convert(1, '2016-05-x') }.to raise_error(ExchangeRate::Converter::InvalidDate)
      end
    end

    context "when date_string param is a future date" do
      it "raises InvalidDate error" do
        expect { described_class.convert(1, (Date.today + 1.day).to_s) }.to raise_error(ExchangeRate::Converter::InvalidDate)
      end
    end

    context "when an entry for a given date exists" do
      let(:date_string) { '2016-05-15' }
      let(:eur_value) { 1.4112 }
      let(:amount) { 1 }
      let!(:exchange_rate) { FactoryGirl.create(:exchange_rate, date: date_string, eur_value: eur_value) }

      it "calculates the exchange rounded to 2 decimal places" do
        expect(described_class.convert(amount, date_string)).to eq(0.71)
      end
    end

    context "when an entry for a given date does not exist" do
      let(:date_string) { '2016-05-12' }
      let(:eur_value) { 1.4112 }
      let(:amount) { 1 }

      context "but an entry for a previous date exists" do
        let!(:exchange_rate) { FactoryGirl.create(:exchange_rate, date: Date.parse(date_string) - 2.day, eur_value: eur_value) }
        let!(:newer_exchange_rate) { FactoryGirl.create(:exchange_rate, date: Date.parse(date_string) - 3.day, eur_value: 1.1111) }
        let!(:older_exchange_rate) { FactoryGirl.create(:exchange_rate, date: Date.parse(date_string) + 1.day, eur_value: 1.1111) }

        it "calculates the value using previous date value" do
          expect(described_class.convert(amount, date_string)).to eq(0.71)
        end
      end

      context "and an older value does not exist" do
        let!(:newer_exchange_rate) { FactoryGirl.create(:exchange_rate, date: Date.parse(date_string) + 1.day, eur_value: 1.1111) }

        it "returns nil" do
          expect(described_class.convert(amount, date_string)).to eq(nil)
        end
      end
    end
  end
end