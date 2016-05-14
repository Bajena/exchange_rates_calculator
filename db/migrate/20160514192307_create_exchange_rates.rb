class CreateExchangeRates < ActiveRecord::Migration[5.0]
  def change
    create_table :exchange_rates do |t|
      t.date :date, null: false
      t.decimal :eur_value, null: false
      t.timestamps
    end

    add_index :exchange_rates, :date, :unique => true
  end
end
