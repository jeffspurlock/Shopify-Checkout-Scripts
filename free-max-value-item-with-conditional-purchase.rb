=begin
PURPOSE: This script allows you to make the highest priced item in your cart free if the customer purchases an item from a specificied group of variant IDs
=end

QUALIFIED_ITEMS = [] # PLACE VARIANT ID'S THAT SHOULD TRIGGER THE CART TO RECEIVE THE DISCOUNT
EXCLUDED_ITEMS = [] # PLACE THE VARIANT ID'S THAT SHOULD NOT RECEIVE THE DISCOUNT, EVEN IF MAX VALUE
DISCOUNT = 0 # ENTER DISCOUNT HERE: EX. 0.10 IS A 10% DISCOUNT, 0.20 IS A 20% DISCOUNT, 0.35 IS A 35% DISCOUNT, ETC.
MESSAGE = "" # Message to display in card explaining discount

class FreeMaxValueItem
    def initialize()
    end
    
    def check(cart)
      qualified_items = QUALIFIED_ITEMS
      eligible_items = []
      chosen_item = 0
      item_value = Money.new(cents: 100000)
      cart.line_items.each do |line_item|
        if qualified_items.include? line_item.variant.id
          eligible_items.push(line_item)
          next
        else 
          next
        end
      end
      eligible_items.each do |eligible_item|
        if eligible_item.variant.price < item_value
          item_value = eligible_item.variant.price
          chosen_item = eligible_item
          next
        end
      end
      return chosen_item
      end
    end
  
    def run(cart, item)
      excluded_items = EXCLUDED_ITEMS
      product = 0
      price = Money.new(cents: 0)
      applied = 0
      cart.line_items.each do |line_item|
        if excluded_items.include? line_item.variant.id
          next
        elsif line_item == item && line_item.quantity == 1
          next
        elsif line_item.variant.price > price
            price = line_item.variant.price
            product = line_item.variant.id
          next
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
  
  CAMPAIGNS = [
    FreeMaxValueItem.new()
    ]
    
  CAMPAIGNS.each do |campaign|
    item = campaign.check(Input.cart)
    if item !=0
      campaign.run(Input.cart, item)
    end
  end
  
  Output.cart = Input.cart