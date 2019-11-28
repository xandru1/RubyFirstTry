require 'json'

class Account
  attr_accessor :name, :currency, :nature, :transactions, :balance

  def initialize(name, currency, balance, nature, transactions)
    @name = name
    @currency = currency
    @balance = balance
    @nature = nature
    @transactions = transactions
  end

  def as_json(options = {})
    {
        name: @name,
        currency: @currency,
        balance: @balance,
        nature: @nature,
        transactions: @transactions
    }
end

  def to_json(*options)
    as_json(*options).to_json(*options)
  end
end
