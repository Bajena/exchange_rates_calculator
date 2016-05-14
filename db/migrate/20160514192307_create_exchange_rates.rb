class CreateExchangeRates < ActiveRecord::Migration[5.0]
  def change
    create_table :exchange_rates do |t|
      t.date :date
      t.decimal :eur_value
      t.timestamps
    end
  end
end
