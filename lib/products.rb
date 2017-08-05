class Products

  attr_accessor :stocked_products, :selection, :product_list

  def initialize
    @stocked_products = list_stocked_products
    @product_list = list_products
  end

  def choose(product)
    @selection = product
    unless check_product_selection(product)
      raise "We do not stock this product"
    end
    unless @stocked_products[product][:quantity] > 0
      raise "This product is not in stock"
    end
    @stocked_products[product][:quantity] -= 1
    return @stocked_products[product][:quantity]
  end

  def check_product_selection(product)
    product_list.detect do |item|
      item == product
    end
  end

  def restock(product, quantity)
    @stocked_products[product][:quantity] += quantity
  end

  private

  def list_stocked_products
    {
      "coke 500ml" => { price:  1.25,  quantity: 0 },
      "coke 330ml" => { price:  0.75,  quantity: 0 },
      "diet coke 500ml" => { price: 1.50, quantity: 0 },
      "diet coke 330ml" => { price:  0.65, quantity: 0 },
      "fanta 330ml" => { price:  0.80,  quantity: 0 },
      "pespi 500ml" => { price:  0.65,  quantity: 0 },
      "water 500ml" => { price:  0.25,  quantity: 0 }
    }
  end

  def list_products
    [
      "coke 500ml", "coke 330ml", "diet coke 500ml", "diet coke 330ml",
      "fanta 330ml", "pespi 500ml", "water 500ml"
    ]
  end
end
