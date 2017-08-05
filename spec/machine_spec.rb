require 'spec_helper'
require 'machine'
require 'pry'

RSpec.describe Machine, machine: true  do
  let(:product_name) { "coke 500ml" }
  before(:each) do
    subject { described_class.new }
    subject.stub(:puts).with(anything())
    # subject.stub(:p).with(anything())
  end


  it 'Request user to load products' do
    expect(subject).to receive(:puts).with("Enter a quantity of coke 500ml to load")
    allow(subject).to receive(:gets).and_return("1")
    subject.take_stock
    products = subject.products
    products.product_list do |product|
      expect(products.stocked_products[product][:quantity]).to eq 1
    end
  end

  it 'Request user to load coins' do
    expect(subject).to receive(:puts).with("Enter a quantity of £2 to load")
    allow(subject).to receive(:gets).and_return("2")
    subject.take_coins
    coins = subject.coins
    coins.denominations do |denominations|
      expect(coins.coins[denominations][:quantity]).to eq 2
    end
  end

  it 'Request user to make a selection' do
    expect(subject).to receive(:puts).with("Please type in the name of your selection")
    expect(subject).to receive(:puts).with("coke 500ml : £1.25")
    allow(subject).to receive(:gets).and_return("coke 500ml")
    subject.select_product
  end

  it 'Request user to enter change' do
    msg = "Enter a coin and press enter. When finished, hit enter twice"
    expect(subject).to receive(:puts).with(msg)
    allow(subject).to receive(:gets).and_return("50p", "")
    subject.get_user_payment
  end

  it 'checks the value of the change is enough to buy the product' do
    subject.user_payment.push('50p', '50p')
    subject.user_selection << "coke 500ml"
    expect(subject.payment_sufficient?).to be false
  end

end
