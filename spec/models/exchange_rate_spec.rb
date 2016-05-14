require 'rails_helper'

describe ExchangeRate do
  describe "validations" do
    describe "eur_value" do
      let(:exchange_rate) { FactoryGirl.build(:exchange_rate, eur_value: eur_value) }

      context "when <= 0" do
        let(:eur_value) { 0 }

        it "is invalid" do
          expect(exchange_rate).to_not be_valid
          expect(exchange_rate.errors).to have_key(:eur_value)
        end
      end

      context "when nil" do
        let(:eur_value) { nil }

        it "is invalid" do
          expect(exchange_rate).to_not be_valid
          expect(exchange_rate.errors).to have_key(:eur_value)
        end
      end
    end

    describe "date" do
      let(:exchange_rate) { FactoryGirl.build(:exchange_rate, date: date) }

      context "when blank" do
        let(:date) { nil }

        it "is invalid" do
          expect(exchange_rate).to_not be_valid
          expect(exchange_rate.errors).to have_key(:date)
        end
      end
    end
  end
end