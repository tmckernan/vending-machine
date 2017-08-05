require 'spec_helper'
require 'coins'
require 'pry'

RSpec.describe Coins, coin: true do

  before(:each) do
    subject { described_class.new }
  end

  context 'initialize coin stack' do
    it 'when created the total amount of coins is 0' do
      expect(subject.value).to eq 0
      expect(subject.coins["1p"][:quantity]).to eq 0
    end
  end

  context 'adds a coin' do
    it 'the number in the stack changes' do
      subject.add_coin("2p", 1)
      expect(subject.coins["2p"][:quantity]).to eq 1
    end

    it 'the value of the whole stack changes' do
      subject.add_coin("2p", 1)
      expect(subject.value).to eq 0.02
    end
  end

  context 'gives change' do
    let(:product_cost) { 0.25 }
    let(:value_paid) { 1.75 }

    before(:each) do
      subject.add_coin("£1", 1)
      subject.add_coin("50p", 1)
    end

    it 'calculates the change required' do
      subject.find_change_required(value_paid, product_cost)
      expect(subject.change_required).to eq 1.5
    end

    it 'returns a hash of coins adding up to that value' do
      subject.find_change_required(value_paid, product_cost)
      expect(subject.coins_returned).to include("£1", "50p")
    end

    it 'removes the coins from the @test_coin_stack' do
      subject.find_change_required(value_paid, product_cost)
      subject.coins_returned
      expect(subject.coins["50p"][:quantity]).to eq 0
      expect(subject.coins["£1"][:quantity]).to eq 0
      expect(subject.value).to eq 0.0
    end
  end
end
