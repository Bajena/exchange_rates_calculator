require 'rails_helper'

describe "exchange_rate rake tasks" do
  describe "#import" do
    let(:subject) { Rake::Task['exchange_rates:import'] }

    before do
      subject.reenable
    end

    it "calls exchange rates importer" do
      expect_any_instance_of(ExchangeRate::Importer).to receive(:import).once
      subject.invoke
    end
  end
end