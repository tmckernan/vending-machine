require 'spec_helper'
require 'products'
require 'pry'

RSpec.describe Products, product: true do
  let(:product_name) { "coke 500ml" }
  before(:each) do
    subject { described_class.new }
  end

  context 'initialize product stack' do
    it 'when created the amount of products is zero' do
      expect(subject.stocked_products[product_name][:quantity]).to be 0
    end

    it 'each product should have a price' do
      expect(subject.stocked_products[product_name][:price]).to eq 1.25
    end
  end

  context 'when in use' do
    before(:each) do
      subject.restock(product_name, 5)
    end

    it 'restock products' do
      subject.restock(product_name, 5)
      expect(subject.stocked_products[product_name][:quantity]).to be 10
    end

    it 'can select a product' do
      subject.choose(product_name)
      expect(subject.selection).to eq product_name
      expect(subject.stocked_products[product_name][:quantity]).to be 4
    end

    it 'can not pick a product which is out of stock' do
      err_msg = "This product is not in stock"
      expect{subject.choose("pespi 500ml")}.to raise_error err_msg
    end

    it 'can not select a product do not stock' do
      err_msg = "We do not stock this product"
      expect{subject.choose("pespi 50ml")}.to raise_error err_msg
    end
  end
end
