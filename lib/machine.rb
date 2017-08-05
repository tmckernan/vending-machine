require_relative './products'
require_relative './coins'

class Machine

  attr_reader :user_selection, :user_payment, :user_selection, :products, :coins

  def initialize
    @products = Products.new
    @coins = Coins.new
    @user_payment = []
    @user_selection = ""
  end

  def take_stock
    @products.product_list.each do |product|
      load_product(product)
    end
  end

  def load_product(product)
      puts "Enter a quantity of #{product} to load"
      quantity = gets.chomp.to_i
      @products.restock(product, quantity)
  end

  def take_coins
    @coins.denominations.each do |coin|
      load_coin(coin)
    end
  end

  def load_coin(coin)
    puts "Enter a quantity of #{coin} to load"
    quantity = gets.chomp.to_i
    @coins.add_coin(coin, quantity)
  end

  def select_product
    puts "Please type in the name of your selection"
    @products.product_list.each do |product|
      price = @products.stocked_products[product][:price]
      puts "#{product} : £#{price}"
    end
    @user_selection = gets.chomp
  end

  def get_user_payment
    request_for_coins
    add_coins_to_user_payment
    remove_empty_payment_values
  end

  def request_for_coins
    puts "Enter a coin and press enter. When finished, hit enter twice"
  end

  def add_coins_to_user_payment
    inserted_coin = gets.chomp
    while !inserted_coin.empty? do
        @user_payment << inserted_coin
        inserted_coin = gets.chomp
    end
  end

  def validate
    return @products.choose(@user_selection) if payment_sufficient?
    get_user_payment
  end

  def payment_sufficient?
    payment_value >= @products.stocked_products[@user_selection][:price]
  end

  def payment_value
    @user_payment.inject(0) do |payment_value, coin|
      payment_value += @coins.coins[coin][:decimal_value]
    end
  end

  def remove_empty_payment_values
    @user_payment.reject! do |coin|
      coin.empty?
    end
  end

  def run
    initial_setup
    vend_products
  end

  def initial_setup
    take_stock
    take_coins
  end

  def vend_products
    take_user_inputs
    if payment_sufficient?
      return_product
      return_change
    else
      p 'Return cash because of insufficient funds'
      p "#{@user_payment}"
    end
  end

  def take_user_inputs
    select_product
    get_user_payment
    validate
  end

  def return_product
    p "Here is your #{@user_selection}:"
  end

  def return_change
    price = @products.stocked_products[@user_selection][:price]
    change = @coins.find_change_required(payment_value, price)
    p "Here is your #{change} change"
    p @coins.coins_returned
  end

end
