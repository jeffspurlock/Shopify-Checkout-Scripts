=begin
PURPOSE: This script allows you to apply product level discounts on items based on the users Customer Tags.
!!IMPORTANT!! In order for this to work, the text placed in the CUSTOMER_TAG variable must matche the customer tag assigned to the customer profile.
=end


DISCOUNT = 0 # ENTER DISCOUNT HERE: EX. 0.10 IS A 10% DISCOUNT, 0.20 IS A 20% DISCOUNT, 0.35 IS A 35% DISCOUNT, ETC.
CUSTOMER_TAG = "" # CUSTOMER TAG TO MATCH TO APPLY DISCOUNT
MESSAGE = "" # MESSAGE TO DISPLAY IN CART EXPLAINING THE DISCOUNT

class DiscountBasedOnTag
  def initialize()
  end
  
  def run(cart)
    if !Input.cart.customer.nil? and Input.cart.customer.tags.include?(CUSTOMER_TAG)
      cart.line_items.each do |line_item|
        line_item.change_line_price(line_item.line_price * (1-DISCOUNT), message: MESSAGE)
      end
    end
  end
end
    
CAMPAIGNS = [
  DiscountBasedOnTag.new()
  ]
  
CAMPAIGNS.each do |campaign|
  campaign.run(Input.cart)
end

Output.cart = Input.cart