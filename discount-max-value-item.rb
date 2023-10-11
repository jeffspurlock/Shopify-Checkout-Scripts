=begin

PURPOSE:
    This script allows you to apply a discount to the highest value item in the cart. Paste this into Script Editor and assign variables.

=end

DISCOUNT = 0 # ENTER DISCOUNT HERE: EX. 0.10 IS A 10% DISCOUNT, 0.20 IS A 20% DISCOUNT, 0.35 IS A 35% DISCOUNT, ETC.
MESSAGE = "" # MESSAGE TO DISPLAY IN CART EXPLAINING THE DISCOUNT


class DiscountMaxValueItem
    def initialize()
    end
    
    def run(cart)
      price = Money.new(cents: 0)
      product = 0
      applied = 0
      cart.line_items.each do |line_item|
        if line_item.line_price > price
          price = line_item.line_price
          product = line_item.variant.id
        end
      end
      cart.line_items.each do |line_item|
        if line_item.variant.id == product
          if line_item.quantity > 1
            new_line_item = line_item.split(take: 1)
            new_line_item.change_line_price(new_line_item.line_price * (1-DISCOUNT), message: MESSAGE)
            cart.line_items << new_line_item
            applied = 1
          else 
            if applied != 1
              line_item.change_line_price(line_item.line_price * (1-DISCOUNT), message: MESSAGE)
            end
          end
        end
      end
    end
  end
  
  CAMPAIGNS = [
    DiscountMaxValueItem.new()
    ]
    
  CAMPAIGNS.each do |campaign|
    campaign.run(Input.cart)
  end
  
  Output.cart = Input.cart