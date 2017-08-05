class Coins
  attr_accessor :value, :coins, :denominations, :change_required

  def initialize
    @coins = coin_stack
    @denominations = denominations_accepted
    @change_required = 0
  end

  def add_coin(denomination, quantity)
    @coins[denomination][:quantity] += quantity
  end

  def value
    value = 0.0
    @denominations.each do |denomination|
      coin = @coins[denomination]
      value += coin[:decimal_value] * coin[:quantity]
    end
    value.round(2)
  end

  def find_change_required(value_paid, product_cost)
    @change_required = (value_paid - product_cost).round(2)
  end

  def coins_returned
    @value_of_change = 0.0
    @return_to_customer = []
    while @change_required != 0.0
      coin = select_coin
      get_change(coin)
      @change_required = (@change_required -= @coins[coin][:decimal_value]).round(2)
    end
    @return_to_customer
  end

  def select_coin
    @denominations.find do |denomination|
      coin = @coins[denomination]
      coin[:decimal_value] <= @change_required && coin[:quantity] > 0
    end
  end

  def get_change(coin)
    remove_from_stack(coin)
    @return_to_customer << coin
    @value_of_change += @coins[coin][:decimal_value]
  end

  def remove_from_stack(coin)
    @coins[coin][:quantity] -= 1
  end

  private

  def coin_stack
    { "£2" => { decimal_value: 2.00, quantity: 0 },
      "£1" => { decimal_value: 1.00, quantity: 0 },
      "50p" => { decimal_value: 0.50, quantity: 0 },
      "20p" => { decimal_value: 0.20, quantity: 0 },
      "10p" => { decimal_value: 0.10, quantity: 0 },
      "5p"  => { decimal_value: 0.05, quantity: 0 },
      "2p"  => { decimal_value: 0.02, quantity: 0 },
      "1p"  => { decimal_value: 0.01, quantity: 0 } }
  end

  def denominations_accepted
    ["£2", "£1", "50p", "20p", "10p", "5p", "2p", "1p"]
  end
end
