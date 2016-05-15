class ExchangeRate
  class Converter
    class InvalidAmount < ArgumentError; end
    class InvalidDate < ArgumentError; end

    private_class_method :new

    def self.convert(amount, date_string)
      new(amount, date_string).convert
    end

    def initialize(amount, date_string)
      self.amount = amount
      self.date_string = date_string

      validate_amount
      validate_date
    end

    def convert
      return unless exchange_rate

      (amount / exchange_rate).round(2).to_f
    end

    private

    attr_accessor :amount, :date_string

    def validate_amount
      raise InvalidAmount.new("amount is not a number") unless amount.is_a?(Numeric)
      raise InvalidAmount.new("amount must be greater or equal to 0.00") if amount < 0
    end

    def validate_date
      date = Date.parse(date_string)
      raise InvalidDate.new("date_string cannot be in the future") if date > Date.today
    rescue ArgumentError, TypeError
      raise InvalidDate.new("date_string is invalid")
    end

    def exchange_rate
      @exchange_rate ||=
        ExchangeRate
          .where("date <= :date", date: date_string)
          .order(date: :desc)
          .first
          .try(:eur_value)
    end
  end
end