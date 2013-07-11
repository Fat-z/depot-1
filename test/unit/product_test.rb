require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  fixtures :products
  
  test "product is not valid without a unique title" do
    product = Product.new(title: products(:ruby).title,
      description: "y", price: 1, image_url: "fred.gif")
    
    assert !product.save
    assert_equal "has already been taken", product.errors[:title].join('; ')
    
  end
  test "product attributes are not empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end
  
  test "product price must be positive" do
    product = Product.new(title:  "hi", description: "y",
      image_url:  "a.jpg")
     product.price = -1
     assert product.invalid?
     assert_equal "must be greater than or equal to 0.01",
      product.errors[:price].join('; ')
      
     product.price = 0
     assert product.invalid?
     assert_equal "must be greater than or equal to 0.01",
      product.errors[:price].join(';')
      
     product.price = 1
     assert product.valid?
  end
  
  def new_product(image_url)
      Product.new(title: "my", description: 'y',
        price: 2, image_url: image_url)
  end
  
  test "image_url" do
    ok = %w{fred.gif.fred.jpg
        http://a.b.c.gif}
     bad = %w{fred.gif/png.more}
     
     ok.each do |name|
       assert new_product(name).valid?, "#{name} valid"
     end
    
     bad.each do |name|
       assert new_product(name).invalid?, "#{name} invalid"
     end
  end
end
