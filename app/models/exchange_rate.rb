class ExchangeRate < ActiveRecord::Base
  validates :eur_value, numericality: { greater_than: 0 }
end